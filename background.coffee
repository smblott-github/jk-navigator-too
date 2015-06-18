
url = "http://static.smblott.org/jk-navigator-too.txt"

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
