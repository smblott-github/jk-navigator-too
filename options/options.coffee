
$ = (id) -> document.getElementById id

textify = (text) ->
  text = JSON.stringify(text, null, 2)
  text = text.replace /^\[\]/, "[\n]"
  text = text.replace /},\n  {/g, "},\n\n  {"
  text

Common.documentReady ->

  chrome.storage.sync.get null, (items) ->
    $("manual-text").textContent = textify items.manual
    $("default-text").textContent = textify items.default
