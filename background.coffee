
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

do ->
  updateIcon = (request, sender) ->
    console.log request
    console.log sender
    if request.show
      chrome.pageAction.show sender.tab.id
    else
      # chrome.pageAction.hide sender.tab.id
    false # We will not be calling sendResponse.

  handlers =
    icon: updateIcon

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if handlers[request.name]?
      handlers[request.name]? request, sender, sendResponse
    else
      false

