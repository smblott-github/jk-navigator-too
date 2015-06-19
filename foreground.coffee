
class Interface
  debug:
    config: true

  constructor: (@config) ->
    @element = null

    @config.offset ?= 100
    @config.nativeJK ?= false

    if @debug.config
      console.log @config.name
      for own key, value of @config
        console.log "  #{key} #{value}" unless key == "name"

    Scroller.init()
    Common.installListener window, "keydown", @keyDownHandler = (event) => @onKeyDown event
    Common.installListener window, "keyup", @KeyUpHandler = (event) => @onKeyUp event
    chrome.runtime.sendMessage name: "icon", show: @config.selectors?

  onKeyDown: (event) ->
    CoreScroller.registerKeydown event
    return unless Common.isActive()
    return if event.repeat

    action = @eventToAction event
    console.log "action:", action if action

    if action == "enter"
      element = @element ? document.activateElement
      element = document.querySelector @config.activeSelector if not element and @config.activeSelector
      return unless element
      return unless Common.isInViewport element

      @activateElement element, event

    else if action in [ "up", "down" ]
      return if @config.nativeJK
      @performUpDown action

    else
      return

    event.preventDefault()
    event.stopImmediatePropagation()

    false

  onKeyUp: (event) ->
    CoreScroller.registerKeyup event

  performUpDown: (action) ->
    elements = @getElements action
    elements.reverse() if action in [ "up" ]

    oldIndex = elements.indexOf @element
    newIndex = Math.max 0, Math.min elements.length - 1, oldIndex + 1

    # console.log oldIndex, newIndex, elements.length, (@element and newIndex == oldIndex) or not elements[newIndex]

    if (@element and newIndex == oldIndex) or not elements[newIndex]
      element = @element ? document.body
      amount = 50
      amount *= -1 if action == "up"
      Scroller.scrollBy element, "y", amount, true
    else
      @selectElement elements[newIndex]

  eventToAction: do ->
    mapping =
      "74": "down"  # "j"
      "75": "up"    # "k"
      "13": "enter" # "<Enter>"

    (event) -> mapping[event.keyCode]

  getElements: (action) ->
    elements = []
    for selector in Common.stringToArray @config.selectors ? []
      try
        elements.push document.querySelectorAll(selector)...

    elements = elements.filter (ele) -> Common.isDisplayed ele

    switch action
      when "up"
        elements = elements.filter (ele) => @getPosition(ele) != "below"
      when "down"
        elements = elements.filter (ele) => @getPosition(ele) != "above"

    # Sort.
    elements = elements.map (ele) -> element: ele, rect: ele.getBoundingClientRect()
    elements.sort (a,b) ->
      if a.rect.top == b.rect.top then a.rect.left - b.rect.left else a.rect.top - b.rect.top
    elements = elements.map (ele) -> ele.element

    # De-duplicate.
    prev = null
    elements.filter (curr) ->
      duplicate = curr == prev
      prev = curr
      not duplicate
    elements.filter (curr) ->
      duplicate = curr == prev
      prev = curr
      not duplicate

  getPosition: (element) ->
    { top, bottom } = element.getBoundingClientRect()
    if top <= 0
      "above"
    else if window.innerHeight <= bottom
      "below"
    else
      "visible"

  selectElement: (element) ->
    if element
      @clearSelection()
      @element = element

      { top, bottom, left, right } = element.getBoundingClientRect()
      # top -= 2; left -= 2
      @overlay = document.createElement "div"
      @overlay.id = "JK-Navigator-Too-Overlay"
      document.body.appendChild @overlay

      zIndex = do (index = getComputedStyle(element).getPropertyValue "z-index") ->
        if /^[0-9]+$/.test index
          "" + (1 + parseInt index)
        else if index == "auto"
          "auto"
          element.childNodes.length * 2
        else
          "2000000000"

      @overlay = document.getElementById "JK-Navigator-Too-Overlay"
      Common.extend @overlay.style,
        position: "absolute"
        left: (window.scrollX + left) + "px"
        top: (window.scrollY + top) + "px"
        width: (right - left) + "px"
        height: (bottom - top) + "px"
        border: "solid #827E8F"
        zIndex: zIndex
        opacity: "0.6"

        "box-sizing": "border-box"
        "pointer-events": "none"

      Common.extend @overlay.style, @config.style if @config.style

      { top, bottom } = @element.getBoundingClientRect()
      isOffTop = top < @config.offset
      isOffBottom = 0 < bottom - (window.innerHeight - @config.offset)
      Scroller.scrollBy @element, "y", top - @config.offset if isOffTop or isOffBottom

  clearSelection: ->
    if @element?
      @overlay.parentNode.removeChild @overlay if @overlay
      @element = @overlay = null

  activateElement: (element, event) ->
    activate = (ele = element) ->
      urlA = document.location.toString().split("#")[0]
      urlB = ele.href?.split("#")[0]

      Common.simulateClick ele, event

    if element.tagName.toLowerCase() == "a"
      activate element
    else
      selectors = [ "a[target=_blank]", "a[href~=http", "a[href~=https]", "a" ]
      selectors = [ (Common.stringToArray @config.activators)..., selectors... ] if @config.activators
      for selector in selectors
        if candidate = element.querySelector selector
          activate candidate
          return

Config =
  lookup: (configs, callback) ->
    url = document.location.toString()
    for config in configs
      try
        for regexp in Common.stringToArray config.regexps
          if (new RegExp regexp).test url
            callback config
            return
      catch
        console.error "regexp failed to compile: #{regexp}"
        console.error config

    callback null

  init: ->
    config = new AsyncDataFetcher (callback) =>
      chrome.storage.local.get [ "configs", "custom" ], (items) =>
        unless chrome.runtime.lastError
          configs = items.configs ? Common.defaults
          if items.custom
            configs = [ items.custom..., configs... ]
          @lookup configs, callback

    config.use (config) ->
      new Interface config if config

Common.documentReady -> Config.init()

