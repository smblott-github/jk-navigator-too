
Common =

  defaults: do ->
    defaults = []

    defaults.push
      name: "Google Search"
      regexps: "^https?://(www\\.)?google\\.([a-z\\.]+)/search\\?"
      selectors: "div#search li.g"
      offset: "50"
      style:
        "border-color": "#0266C8"
        opacity: "0.2"

    defaults.push
      name: "DuckDuckGo Search"
      regexps: "^https://duckduckgo\\.com/\\?q="
      selectors: [
        "div#links div.result__body"
        "div#zero_click_wrapper div.zci__main div.zci__body"
      ]
      offset: "50"
      style:
        "z-index": 2000000000

    defaults.push
      name: "Youtube Search Results"
      regexps: "^https?://www\\.youtube\\.com/results\\?."
      selectors: "ol.item-section > li"
      activators: 'a[href^="/watch"]'

    defaults.push
      name: "Facebook Home Page"
      regexps: "^https?://www\\.facebook\\.com"
      selectors: "div[data-timestamp] > div.userContentWrapper"
      activators: [ "div.fbstoryattachmentimage img", "a[rel=theater]" ]
      style:
        "border-color": "#3b5998"
        opacity: "0.2"

    # # This matches all pages.
    # # With no selectors, the page smooth scrolls on "j" and "k".
    # defaults.push
    #   name: "Generic J/K Scrolling"
    #   regexps: "."

    defaults

  documentReady: (func) ->
    if document.readyState == "loading"
      window.addEventListener "DOMContentLoaded", handler = ->
        window.removeEventListener "DOMContentLoaded", handler
        func()
    else
      func()

  installListener: (element, event, callback) ->
    element.addEventListener event, callback, true

  # Give objects (including elements) distinct identities.
  identity: do ->
    identities = []
    getId: (obj) ->
      index = identities.indexOf obj
      if index < 0
        index = identities.length
        identities.push obj
      index
    getObj: (id) -> identities[id]

  # Returns the active element (if it is editable) or null.
  getEditableElement: do ->
    nonEditableInputs = [ "radio", "checkbox" ]
    editableNodeNames = [ "textarea" ]

    (element = document.activeElement) ->
      nodeName = element.nodeName?.toLowerCase()
      return element if false or
        element.isContentEditable or
        (nodeName? and nodeName == "input" and element.type not in nonEditableInputs) or
        (nodeName? and nodeName in editableNodeNames)
      null

  isActive: ->
    not @getEditableElement()?

  stringToArray: (thing) ->
    if "string" == typeof thing then [ thing ] else thing

  # Convenience wrapper for setTimeout (with the arguments around the other way).
  setTimeout: (ms, func) -> setTimeout func, ms

  # Like Nodejs's nextTick.
  nextTick: (func) -> @setTimeout 0, func

  # Extend an object with additional properties.
  extend: (hash1, hash2) ->
    hash1[key] = value for own key, value of hash2
    hash1

  # FIXME.
  chromeStoreKey: "klbcooigafjpbiahdjccmajnaehomajc"

  isChromeStoreVersion: do ->
    0 == chrome.extension.getURL("").indexOf "chrome-extension://klbcooigafjpbiahdjccmajnaehomajc"

  log: (args...) ->
    console.log args... unless @isChromeStoreVersion

  simulateClick: (element, modifiers) ->
    modifiers ||= {}

    eventSequence = ["mouseover", "mousedown", "mouseup", "click"]
    for event in eventSequence
      mouseEvent = document.createEvent("MouseEvents")
      mouseEvent.initMouseEvent(event, true, true, window, 1, 0, 0, 0, 0, modifiers.ctrlKey, modifiers.altKey,
      modifiers.shiftKey, modifiers.metaKey, 0, null)
      # Debugging note: Firefox will not execute the element's default action if we dispatch this click event,
      # but Webkit will. Dispatching a click on an input box does not seem to focus it; we do that separately
      element.dispatchEvent(mouseEvent)

  # detects both literals and dynamically created strings
  isString: (obj) -> typeof obj == 'string' or obj instanceof String

  #
  # Returns the first visible clientRect of an element if it exists. Otherwise it returns null.
  #
  # WARNING: If testChildren = true then the rects of visible (eg. floated) children may be returned instead.
  # This is used for LinkHints and focusInput, **BUT IS UNSUITABLE FOR MOST OTHER PURPOSES**.
  #
  getVisibleClientRect: (element, testChildren = false) ->
    # Note: this call will be expensive if we modify the DOM in between calls.
    clientRects = (Rect.copy clientRect for clientRect in element.getClientRects())

    # Inline elements with font-size: 0px; will declare a height of zero, even if a child with non-zero
    # font-size contains text.
    isInlineZeroHeight = ->
      elementComputedStyle = window.getComputedStyle element, null
      isInlineZeroFontSize = (0 == elementComputedStyle.getPropertyValue("display").indexOf "inline") and
        (elementComputedStyle.getPropertyValue("font-size") == "0px")
      # Override the function to return this value for the rest of this context.
      isInlineZeroHeight = -> isInlineZeroFontSize
      isInlineZeroFontSize

    for clientRect in clientRects
      # If the link has zero dimensions, it may be wrapping visible but floated elements. Check for this.
      if (clientRect.width == 0 or clientRect.height == 0) and testChildren
        for child in element.children
          computedStyle = window.getComputedStyle(child, null)
          # Ignore child elements which are not floated and not absolutely positioned for parent elements
          # with zero width/height, as long as the case described at isInlineZeroHeight does not apply.
          # NOTE(mrmr1993): This ignores floated/absolutely positioned descendants nested within inline
          # children.
          continue if (computedStyle.getPropertyValue("float") == "none" and
            computedStyle.getPropertyValue("position") != "absolute" and
            not (clientRect.height == 0 and isInlineZeroHeight() and
              0 == computedStyle.getPropertyValue("display").indexOf "inline"))
          childClientRect = @getVisibleClientRect child, true
          continue if childClientRect == null or childClientRect.width < 3 or childClientRect.height < 3
          return childClientRect

      else
        clientRect = @cropRectToVisible clientRect

        continue if clientRect == null or clientRect.width < 3 or clientRect.height < 3

        # eliminate invisible elements (see test_harnesses/visibility_test.html)
        computedStyle = window.getComputedStyle(element, null)
        continue if computedStyle.getPropertyValue('visibility') != 'visible'

        return clientRect

    null

  isDisplayed: (element) ->
    "none" != getComputedStyle(element).getPropertyValue "display"

  isInViewport: (element) ->
    { top, bottom } = element.getBoundingClientRect()
    offScreen = bottom <= 0 or window.innerHeight <= top
    not offScreen

  #
  # Bounds the rect by the current viewport dimensions. If the rect is offscreen or has a height or width < 3
  # then null is returned instead of a rect.
  #
  cropRectToVisible: (rect) ->
    boundedRect = Rect.create(
      Math.max(rect.left, 0)
      Math.max(rect.top, 0)
      rect.right
      rect.bottom
    )
    if boundedRect.top >= window.innerHeight - 4 or boundedRect.left >= window.innerWidth - 4
      null
    else
      boundedRect


# This is a simple class for the common case where we want to use some data value which may be immediately
# available, or for which we may have to wait.  It implements a use-immediately-or-wait queue, and calls the
# fetch function to fetch the data asynchronously.
class AsyncDataFetcher
  constructor: (fetch) ->
    @data = null
    @queue = []
    Common.nextTick =>
      fetch (@data) =>
        callback @data for callback in @queue
        @queue = null

  use: (callback) ->
    if @data? then callback @data else @queue.push callback

root = exports ? window
root.Common = Common
root.AsyncDataFetcher = AsyncDataFetcher
