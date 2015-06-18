
do ->
  forceConfigUpdate = true

  chrome.storage.sync.get "configs", (items) =>
    unless chrome.runtime.lastError
      if forceConfigUpdate or not items.configs
        obj = {}; obj.configs = Common.defaults
        chrome.storage.sync.set obj

do ->
  updateIcon = (request, sender) ->
    chrome.pageAction.show sender.tab.id
    false # We will not be calling sendResponse.

  handlers =
    icon: updateIcon

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if handlers[request.name]?
      handlers[request.name]? request, sender, sendResponse
    else
      false

do ->
  urls = [ "http://static.smblott.org/jk-navigator-too.txt" ]
  urls = [ "http://smblott.org/jk-navigator-too.txt" ]

  success = (xhr, url) ->
    text = xhr.responseText
    try
      json = JSON.parse text
    catch
      console.error "JSON parse error", url
      return
    obj = {}; obj.custom = json
    chrome.storage.sync.set obj, ->
      if chrome.runtime.lastError
        console.error "storage error", url
      else
        console.log "ok", url

  failure = (xhr, url) ->
    console.error "fetch error", url

  for url in urls
    do (url) ->
      xhr = new XMLHttpRequest()
      xhr.open "GET", url, true
      xhr.timeout = 5000
      xhr.ontimeout = xhr.onerror = (xhr) -> failure xhr, url

      xhr.onreadystatechange = ->
        if xhr.readyState == 4
          console.log xhr
          (if xhr.status == 200 then success else failure) xhr, url

      xhr.send()

