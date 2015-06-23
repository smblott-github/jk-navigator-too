Common =

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

  # Poor man's structural equality.
  structurallyEqual: (a, b) ->
    if a == b
      true
    else if not a? and not b?
      true
    else if not a? or not b?
      false
    else if typeof(a) != typeof b
      false
    else if "string" == typeof a
      a == b
    else if a.length? or b.length?
      return false unless a.length? and b.length?
      return false unless a.length == b.length
      for e, i in a
        return false unless @structurallyEqual e, b[i]
      true
    else if "object" == typeof a
      ka = Object.keys a; kb = Object.keys b
      return false unless ka.length? and kb.length?
      return false unless ka.length == kb.length
      ka.sort(); kb.sort()
      return false unless @structurallyEqual ka, kb
      for own k, v of a
        return false unless @structurallyEqual v, b[k]
      true
    else
      a == b

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

  normaliseUrl: (url) ->
    # We exclude anchors.
    url = url.split("#")[0]
    # We include the presence of parameters, but not the parameters themselves.
    url = "#{url.split("&")[0]}&" if 0 <= url.indexOf "&"
    url

  # FIXME.
  chromeStoreKey: "klbcooigafjpbiahdjccmajnaehomajc"

  isChromeStoreVersion: do ->
    0 == chrome?.extension.getURL("").indexOf "chrome-extension://klbcooigafjpbiahdjccmajnaehomajc"

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

  wget: (url, callback) ->
    date = new Date().getTime()
    url = "#{url}?date=#{date}"
    xhr = new XMLHttpRequest()
    xhr.open "GET", url, true
    xhr.timeout = 2500

    response =
      xhr: xhr
      date: date

    failure = (error) ->
      callback Common.extend response, success: false, error: error

    xhr.ontimeout = -> failure "HTTP request timed out."
    xhr.onerror = -> failure "Unknown HTTP error."

    xhr.onreadystatechange = ->
      if xhr.readyState == 4
        if xhr.status != 200
          failure "Error - HTTP status: #{xhr.status}."
        else if not xhr.responseText
          failure "Error - HTTP response text empty."
        else
          callback Common.extend response, success: true, text: xhr.responseText

    xhr.send()

  getKey: (url) -> "obj-#{url}"
  getSuccessKey: (url) -> "success-#{url}"
  getShowKey: (url) -> "show-#{url}"
  getRules: (configs) -> configs.configs ? configs
  getMeta: (configs) -> configs.meta

  mkConfigs: (configs, meta = null) ->
    process.stdout.write JSON.stringify { configs, meta }, null, "  "

  log: (args...) ->
    chrome.runtime.sendMessage name: "log", message: args if document.hasFocus()

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

# A simple cache. Entries used within two expiry periods are retained, otherwise they are discarded.
# At most 2 * @entries entries are retained.
class SimpleCache
  # expiry: expiry time in milliseconds (default, one hour)
  # entries: maximum number of entries in @cache (there may be up to this many entries in @previous, too)
  constructor: (@expiry = 60 * 60 * 1000, @entries = 1000) ->
    @cache = {}
    @previous = {}
    @lastRotation = new Date()

  has: (key) ->
    @rotate()
    (key of @cache) or key of @previous

  # Set value, and return that value
  set: (key, value = null) ->
    @rotate()
    delete @previous[key]
    @cache[key] = value

  get: (key) ->
    @rotate()
    if key of @cache
      @cache[key]
    else if key of @previous
      @cache[key] = @previous[key]
      delete @previous[key]
      @cache[key]
    else
      null

  rotate: (force = false) ->
    Common.nextTick =>
      if force or @entries < Object.keys(@cache).length or @expiry < new Date() - @lastRotation
        @lastRotation = new Date()
        @previous = @cache
        @cache = {}

  clear: ->
    @rotate true
    @rotate true

root = exports ? window
root.Common = Common
root.AsyncDataFetcher = AsyncDataFetcher
root.SimpleCache = SimpleCache
