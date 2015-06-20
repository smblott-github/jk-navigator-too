
class Interface
  debug:
    config: false
    selector: false

  constructor: (@config, element = null) ->
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
    Common.installListener window, "scroll", @scrollHandler = => @onScroll()
    chrome.runtime.sendMessage name: "icon", show: @config.selectors?

    @selectElement element false if element
    @onScroll focusDelay: 0

  onKeyDown: (event) ->
    # console.clear()
    CoreScroller.registerKeydown event
    return unless Common.isActive()
    return if event.repeat

    switch action = @eventToAction event
      when "enter"
        element = @element ? document.activateElement
        element ?= @querySelector document, @config.activeSelector if @config.activeSelector
        return unless element and Common.isInViewport element

        @activateElement element, event

      when "up", "down"
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
    elements.reverse() if action == "up"

    oldIndex = elements.indexOf @element
    newIndex = Math.max 0, Math.min elements.length - 1, oldIndex + 1

    if (@element and newIndex == oldIndex) or not elements[newIndex]
      element = @element ? document.body
      amount = 100 * if action == "up" then -1 else 1
      Scroller.scrollBy (@element ? document.body), "y", amount, true
    else
      # Sometimes, we just scroll to the previously selected element, which feels better from a UX
      # perspective.
      if @element and newIndex != oldIndex
        { top, bottom } = @element.getBoundingClientRect()
        if action == "up" and top < 0
          newIndex = oldIndex
        else if action == "down" and @config.offset < top and innerHeight < bottom
          newIndex = oldIndex

      @selectElement elements[newIndex]

  eventToAction: do ->
    mapping =
      "74": "down"  # "j"
      "75": "up"    # "k"
      "13": "enter" # "<Enter>"

    (event) -> mapping[event.keyCode]

  # Return an array of elements which may be the target of this movement.
  getElements: (action) ->
    elements = []
    for selector in Common.stringToArray @config.selectors ? []
      elements.push @querySelector(document, selector, true)...

    elements = elements.filter (ele) -> Common.isDisplayed ele

    switch action
      when "up"
        elements = elements.filter (ele) => @getPosition(ele) != "below"
      when "down"
        elements = elements.filter (ele) => @getPosition(ele) != "above"

    # Sort (and discard elements which are too small).
    elements = elements.map (ele) -> element: ele, rect: ele.getBoundingClientRect()
    elements = elements.filter (ele) -> 100 < (ele.rect.bottom - ele.rect.top) * (ele.rect.right - ele.rect.left)
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
    if top <= 0
      "above"
    else if innerHeight <= bottom
      "below"
    else
      "visible"

  selectElement: (element, shouldScroll = true) ->
    if element
      @clearSelection()
      @element = document.activeElement = element

      { top, bottom, left, right } = element.getBoundingClientRect()
      borderWidth = 2; extraBorder = 2
      top -= borderWidth + extraBorder; left -= borderWidth + extraBorder
      bottom += borderWidth + extraBorder; right += borderWidth + extraBorder

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
        "border-width": "#{borderWidth}px"
        zIndex: zIndex
        opacity: "0.6"

        "box-sizing": "border-box"
        "pointer-events": "none"

      Common.extend @overlay.style, @config.style if @config.style

      if shouldScroll
        { top, bottom } = @element.getBoundingClientRect()
        isOffTop = top < @config.offset
        isOffBottom = 0 < bottom - (innerHeight - @config.offset)
        Scroller.scrollBy @element, "y", top - @config.offset # if isOffTop or isOffBottom

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
          if candidate = @querySelector element, selector
            activate candidate
            return

  querySelector: (element, selector, all = false) ->
    search = (selector) ->
      if all then element.querySelectorAll selector else element.querySelector selector
    try
      console.log "#{selector} #{all}:" if @debug.selector
      console.log "  #{search selector}" if @debug.selector
      search selector
    catch
      console.error "bad CSS selector: #{selector}"
      if all then [] else null

  # If we scroll, and there's already a selected element, and that element goes out of the viewport, then we
  # select the top-most visible selectable element.
  onScroll: do ->
    timer = null

    cancel = ->
      if timer
        clearTimeout timer; timer = null

    (event) ->
      delay = event?.focusDelay ? 200
      cancel()
      unless @element and Common.isInViewport @element
        if element = @getElements("down")[0]
          timer = Common.setTimeout delay, =>
            timer = null
            unless @element and Common.isInViewport @element
              @selectElement element, false

init = ->
  chrome.runtime.sendMessage { name: "config", url: document.location.toString() }, (config) ->
    console.log "config:", config?.name ? "disabled"
    new Interface config if config

if document?.location?.toString() then init() else Common.documentReady init

