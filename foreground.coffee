
class Interface
  constructor: (@config, element = null) ->
    @element = null

    @config.offset ?= 25
    @config.native ?= false
    @config.selectors ?= []

    chrome.runtime.sendMessage name: "icon", show: true if @config.selectors?
    if element
      @selectElement element, false
    else if element = @getElements("down")[0]
       @selectElement element, false

  deactivate: ->
    chrome.runtime.sendMessage name: "icon", show: false
    @clearSelection()

  onKeydown: (event) ->
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
        return if event.ctrlKey or event.altKey or @config.native
        @performUpDown action, event

      else
        return

    event.preventDefault()
    event.stopImmediatePropagation()
    false

  onKeyup: (event) ->
    CoreScroller.registerKeyup event

  performUpDown: (action, event) ->
    elements = @getElements action

    oldIndex = elements.indexOf @element
    newIndex = Math.max 0, Math.min elements.length - 1, oldIndex + 1

    if (@element and newIndex == oldIndex) or not elements[newIndex] or event.shiftKey
      element = @element ? document.body
      amount = 100 * if action == "up" then -1 else 1
      Scroller.scrollBy (@element ? document.body), "y", amount, true
    else
      # Sometimes, we just scroll to the previously selected element, which feels better from a UX
      # perspective.
      # Delta is a wiggle fudgement.  If we're closer than delta, then we that assume the current element is
      # already in the right position.
      delta = 10
      if 0 <= oldIndex < newIndex
        if Common.canScroll action
          { top, bottom } = @element.getBoundingClientRect()
          if action == "up" and top + delta < @config.offset
            newIndex = oldIndex
          else if action == "down" and @config.offset + delta < top
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

    if action == "up" then elements.reverse() else elements

  getPosition: (element) ->
    { top, bottom } = element.getBoundingClientRect()
    if top <= 0
      "above"
    else if innerHeight <= bottom
      "below"
    else
      "visible"

  # This like the "Show Photo" button on Twitter cause the size of the element to change.  We watch for such
  # changes, and re-draw the overlay.
  observeElement: do ->
    observeFunction = null
    observer = new MutationObserver (mutations) -> observeFunction? mutations

    (element) ->
      if element
        observer.disconnect()
        observer.observe element,
          childList: true
          attributes: true
          characterData: true
          subtree: true
        observeFunction = (mutations) =>
          if Common.isDisplayed element
            # We could probably be more selective as to the types of mutations for which we re-select the
            # current element.
            @selectElement element, false
          else
            @clearSelection()
      else
        observeFunction = null
        observer.disconnect()

  selectElement: (element, shouldScroll = true) ->
    if element
      @clearSelection()
      @element = document.activeElement = element
      @observeElement @element

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
      @observeElement null
      @onScroll null, true

  activateElement: (element, event) ->
    # We assume <Shift> and <Alt> by default.  The user can override (revert) that by using these modifiers.
    # This may be counterintuitive, however if gives both the best default behaviour and the possibility for
    # the user the alter it should they wish.
    keyEvent = shiftKey: true, ctrlKey: true, altKey: event.altKey
    for key in [ "shiftKey", "ctrlKey" ]
      delete keyEvent[key] if event[key]

    activate = (ele = element) =>
      console.log "activate", ele
      unless @config.noclick
        Common.simulateClick ele, keyEvent
        ele.blur()

    if element.tagName.toLowerCase() == "a"
      activate element
    else
      selectors = [ "a[target=_blank]", "a[href~=http", "a[href~=https]", "a" ]
      selectors = [ (Common.stringToArray @config.activators)..., selectors... ] if @config.activators
      for selector in selectors
        if candidate = @querySelector element, selector
          activate candidate
          return
      # OK.  Just click the element, then.
      activate element

  querySelector: (element, selector, all = false) ->
    try
      results = element.querySelectorAll selector
      results = (ele for ele in results when Common.isDisplayed ele)
      if all then results else results[0]
    catch
      console.error "Bad CSS selector: #{all} #{selector}"
      if all then [] else null


  # If we scroll, and there's already a selected element, and that element goes out of the viewport, then we
  # select the top-most visible selectable element.
  onScroll: do ->
    delay = 50
    timer = null
    previousPageYOffset = pageYOffset

    cancel = ->
      if timer
        clearTimeout timer; timer = null

    (event, clear = false) ->
      # Figure out the direction of the last scroll.  If we're at or close to the top of the window, then we
      # just assume "down".
      direction = if previousPageYOffset < pageYOffset or pageYOffset < 100 then "down" else "up"
      previousPageYOffset = pageYOffset
      cancel()
      unless clear
        timer = Common.setTimeout delay, =>
          timer = null
          if @element and not Common.isInViewport @element
            @clearSelection()
          if not @element
            if element = (ele for ele in @getElements direction when Common.isInViewport ele)[0]
              @selectElement element, false

Wrapper =
  interface: null

  installListeners: do ->
    installedListeners = false
    ->
      unless installedListeners
        installedListeners = true
        Common.installListener window, "keydown", (event) => @interface?.onKeydown event
        Common.installListener window, "keyup", (event) => @interface?.onKeyup event
        Common.installListener window, "scroll", (event) => @interface?.onScroll event

  init: ->
    Scroller.init()
    @launch()

    chrome.runtime.onMessage.addListener (request, sender, sendResponse) =>
      @launch() if request.name == "refresh"
      false

  launch: ->
    element = @interface?.element
    @interface?.deactivate()
    @interface = null

    chrome.runtime.sendMessage { name: "config", url: document.location.toString() }, (config) =>
      @installListeners()
      @interface = new Interface(config, element) if config

Common.documentReady -> Wrapper.init()

