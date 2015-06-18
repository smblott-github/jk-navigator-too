
class Interface
  constructor: (@config) ->
    @element = null
    @offset ?= 100
    @colour ?= "#fcc"

    Scroller.init()
    Common.installListener window, "keydown", @keyDownHandler = (event) => @onKeyDown event
    Common.installListener window, "keyup", @KeyUpHandler = (event) => @onKeyUp event
    chrome.runtime.sendMessage name: "icon"

  onKeyDown: (event) ->
    CoreScroller.registerKeydown event
    return unless Common.isActive()
    return unless action = @eventToAction event

    event.preventDefault()
    event.stopImmediatePropagation()

    return if event.repeat

    if @element
      @clearSelection() unless @getPosition(@element) == "visible"

    if action == "enter" and @element
      @activateElement @element

    else if action in [ "up", "down" ]
      @performUpDown action

    false

  onKeyUp: (event) ->
    CoreScroller.registerKeyup event

  performUpDown: (action) ->
    elements = @getElements action
    elements.reverse() if action in [ "up" ]

    oldIndex = elements.indexOf @element
    newIndex = Math.max 0, Math.min elements.length - 1, oldIndex + 1

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

    (event) ->
      if event.ctrlKey or event.metaKey or event.shiftKey
        null
      else
        mapping[event.keyCode]

  getElements: (action) ->
    elements = []
    for selector in Common.stringToArray @config.selectors
      try
        elements.push document.querySelectorAll(selector)...

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

  getPosition: (element) ->
    { top, bottom } = element.getBoundingClientRect()
    if bottom <= 0
      "above"
    else if window.innerHeight <= top
      "below"
    else
      "visible"

  selectElement: (element) ->
    if element
      @clearSelection()
      @element = element

      @previousBackgroundColor = element.style.backgroundColor
      @element.style.backgroundColor = @colour

      { top, bottom } = @element.getBoundingClientRect()
      isOffTop = top < @offset
      isOffBottom = 0 < bottom - (window.innerHeight - @offset)
      Scroller.scrollBy @element, "y", top - @offset if isOffTop or isOffBottom

  clearSelection: ->
    if @element?
      @element.style.backgroundColor = @previousBackgroundColor
      @element = null

  activateElement: (element) ->
    activate = (ele = element) ->
      urlA = document.location.toString().split("#")[0]
      urlB = ele.href?.split("#")[0]

      modifiers = {}
      unless urlA and urlB and urlA == urlB
        modifiers = ctrlKey: true, shiftKey: true

      Common.simulateClick ele, modifiers

    if element.tagName.toLowerCase() == "a"
      activate element
    else
      activate element.getElementsByTagName('a')[0]

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
      chrome.storage.sync.get [ "configs", "custom" ], (items) =>
        unless chrome.runtime.lastError
          configs = items.configs ? Common.defaults
          if items.custom
            configs = [ items.custom..., configs... ]
          @lookup configs, callback

    config.use (config) ->
      new Interface config if config

Common.documentReady -> Config.init()

