
do ->
  # Force reset to default (for dev/debug only).
  forceReset = false

  setDefaults = ->
    defaults = network: []
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
        for key in networkKeys
          configs.push Common.getRules(items[key])... if items[key]
        configs.sort (a,b) -> (a.priority ? 0) - (b.priority ? 0)
        console.log "  #{config.name}" for config in configs

        chrome.windows.getAll { populate: true }, (windows) ->
          for window in windows
            for tab in window.tabs
              chrome.tabs.sendMessage tab.id, name: "refresh"

  getConfigs()
  chrome.storage.onChanged.addListener getConfigs

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

  (request, sender, sendResponse) ->
    lookup Common.normaliseUrl(request.url), sendResponse

updateIcon = (request, sender) ->
  if request.show
    chrome.pageAction.show sender.tab.id
  else
    chrome.pageAction.hide sender.tab.id
  false # We will not be calling sendResponse.

consoleLog = (request, sender) ->
  console.log "#{sender.tab.id}", request.message...
  false # We will not be calling sendResponse.

do ->
  handlers =
    icon: updateIcon
    config: getConfig
    log: consoleLog

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if handlers[request.name]?
      handlers[request.name]? request, sender, sendResponse
    else
      false

chrome.webNavigation.onHistoryStateUpdated.addListener (details) ->
  chrome.tabs.sendMessage details.tabId, name: "refresh"

