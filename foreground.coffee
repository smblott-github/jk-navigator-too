
lookup = (configs, callback) ->
  url = document.location.toString()
  for config in configs
    try
      for regexp in Common.stringToArray config.regexps
        console.log regexp, url
        return callback config if (new RegExp regexp).test url
  callback null

Common.documentReady ->
  config = new AsyncDataFetcher (callback) ->
    chrome.storage.sync.get "configs", (items) ->
      unless chrome.runtime.lastError
        configs = items.configs ? Common.defaults
        lookup configs, callback
        unless false # items.configs
          obj = {}; obj.configs = Common.defaults
          chrome.storage.sync.set obj

  config.use (config) ->
    new Interface config

class Interface
  constructor: (@config) ->
    Scroller.init()
    @element = null

    Common.installListener window, "keydown", @handler = (event) => @onKeyDown event

  onKeyDown: (event) ->
    return unless Common.isActive()
    return unless action = @eventToAction event
    event.preventDefault()
    event.stopImmediatePropagation()
    elements = @getElements action

    if @element
      @clearSelection() unless @getPosition(@element) == "visible"

    if action in [ "up", "top" ]
      elements = elements.reverse()

    if 0 < elements.length
      switch action
        when "enter"
          @activateElement @element if @element
        when "up", "down"
          index = elements.indexOf @element
          newIndex = if 0 <= index then index + 1 else 0
          @selectElement elements[newIndex]
    false

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
      elements.push document.querySelectorAll(selector)...

    switch action
      when "up" then elements = elements.filter (ele) => @getPosition(ele) != "below"
      when "down" then elements = elements.filter (ele) => @getPosition(ele) != "above"

    # FIXME: de-duplicate, sort (?).
    elements

  getPosition: (element) ->
    { top, bottom } = element.getBoundingClientRect()
    if bottom < 0
      "above"
    else if window.innerHeight < top
      "below"
    else
      "visible"

  selectElement: (element) ->
    if element
      @clearSelection()
      @element = element

      @previousBackgroundColor = element.style.backgroundColor
      @element.style.backgroundColor = @config.color ? "#fcc"

      { top, bottom } = @element.getBoundingClientRect()
      isOffTop = top < 100
      isOffBottom = 0 < bottom - (window.innerHeight - 100)
      Scroller.scrollBy "y", top - 100 if isOffTop or isOffBottom

  clearSelection: ->
    if @element?
      @element.style.backgroundColor = @previousBackgroundColor
      @element = null

  activateElement: (element) ->
    if element
      activate = (ele) ->
        urlA = document.location.toString().split("#")[0]
        urlB = ele.href?.split("#")[0]

        modifiers = {}
        unless urlA and urlB and urlA == urlB
          modifiers = ctrlKey: true, shiftKey: true

        Common.simulateClick ele, modifiers

      if element.tagName.toLowerCase() == "a"
        activate element
      else
        ele = element.getElementsByTagName('a')[0]
        activate ele if ele

