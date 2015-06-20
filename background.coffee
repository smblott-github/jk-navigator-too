
do ->
  defaults =
    manual: []
    network: [ "http://smblott.org/jk-navigator-too.txt" ]
    default: Common.defaults

  chrome.storage.sync.get Object.keys(defaults), (items) ->
    unless chrome.runtime.lastError
      for own key of items
        delete defaults[key] if items[key]?
      chrome.storage.sync.set defaults
      Common.fetchNetwork url for url in items.network

getConfig = do ->
  cache = new SimpleCache 1000 * 60 * 60 * 24, 2000
  configs = []
  regexpCache = {}

  getConfigs = ->
    chrome.storage.sync.get null, (items) ->
      unless chrome.runtime.lastError
        # We use try because the storage area may not yet have been initialised.
        try
          newConfigs = []
          networkKeys = items.network.map (url) => Common.getObjKey url
          for key in [ "manual", networkKeys..., "default" ]
            newConfigs.push items[key]...  if items[key]
          configs = newConfigs
          cache.clear()
          console.log "configs updated"
        catch
          console.log "configs not yet available"

  getConfigs()
  chrome.storage.onChanged.addListener getConfigs

  lookup = (url, sendResponse) ->
    for config in configs
      continue if config.disabled
      try
        for regexp in Common.stringToArray config.regexps
          if (new RegExp regexp).test url
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
    url = normaliseUrl request.url
    if cache.has url
      console.log "cache hit: #{url}"
      sendResponse cache.get url
      false
    else
      lookup url, sendResponse
      true # We *will* be calling sendResponse.

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

