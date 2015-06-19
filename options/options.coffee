
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

    for url, index in items.network
      do (url, index) ->
        # $("network").appendChild document.createElement "hr"
        template = document.querySelector('#network-template').content
        node = document.importNode template, true
        node.querySelector(".network-url").textContent = url
        node.querySelector(".network-text").textContent = textify items[Common.getObjKey url]
        $("network").appendChild node


