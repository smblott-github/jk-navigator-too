
do ->
  # Force reset to default (for dev/debug only).
  forceReset = false

  setDefaults = ->
    defaults = custom: [], network: []
    chrome.storage.sync.get Object.keys(defaults), (items) ->
      unless chrome.runtime.lastError
        for own key of defaults
          delete defaults[key] if items[key] and not forceReset
        if 0 < Object.keys(defaults).length
          console.log "setting defaults:", defaults
          chrome.storage.sync.set defaults

  if forceReset
    chrome.storage.sync.get null, (items) ->
      console.log "removing:", Object.keys(items)...
      chrome.storage.sync.remove Object.keys(items), setDefaults
  else
    setDefaults()

getConfig = do ->
  configs = []
  cache = new SimpleCache 1000 * 60 * 60 * 36, 2000

  testRegexp = do ->
    regexpCache = new SimpleCache 1000 * 60 * 60 * 24 * 7, 2000

    (url, regexp) ->
      if regexpCache.has regexp
        regexpCache.get(regexp).test url
      else
        regexpCache.set regexp, new RegExp regexp
        testRegexp url, regexp

  getConfigs = ->
    console.log "updating configs..."
    chrome.storage.sync.get null, (items) ->
      unless chrome.runtime.lastError
        cache.clear()
        configs = []
        networkKeys =
          # We need "try" here because initialisation may not yet be complete.
          try items.network.map (url) -> Common.getKey url
          catch then []
        for key in [ "custom", networkKeys...]
          configs.push items[key]...  if items[key]
        configs.push Common.default...
        console.log "  #{config.name}" for config in configs

  getConfigs()
  chrome.storage.onChanged.addListener (changes, area) ->
    getConfigs() if area == "sync" and changes.network

  lookup = (url, sendResponse) ->
    if cache.has url
      console.log "#{url} -> cached"
      sendResponse cache.get url

    else
      for config in configs
        continue if config.disabled
        try
          for regexp in Common.stringToArray config.regexps
            if testRegexp url, regexp
              console.log "#{url} -> #{config.name}"
              sendResponse cache.set url, config
              return
        catch
          console.error "regexp failed to compile: #{regexp}"
          console.error config

      console.log "#{url} -> disabled"
      sendResponse cache.set url, null

  normaliseUrl = (url) ->
    # We exclude anchors.
    url = url.split("#")[0]
    # We include the presence of parameters, but not the parameters themselves.
    url = "#{url.split("&")[0]}&" if 0 <= url.indexOf "&"
    url

  (request, sender, sendResponse) ->
    lookup normaliseUrl(request.url), sendResponse

updateIcon = (request, sender) ->
  if request.show
    chrome.pageAction.show sender.tab.id
  else
    # chrome.pageAction.hide sender.tab.id
  false # We will not be calling sendResponse.

do ->
  handlers =
    icon: updateIcon
    config: getConfig

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if handlers[request.name]?
      handlers[request.name]? request, sender, sendResponse
    else
      false

