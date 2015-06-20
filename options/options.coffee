
$ = (id) -> document.getElementById id

textify = (text) ->
  text = JSON.stringify(text, null, 2)
  text = text.replace /^\[\]/, "[\n]"
  text = text.replace /},\n  {/g, "},\n\n  {"
  text

class RuleSet
  constructor: (container, url, rules) ->
    template = document.querySelector('#container-template').content
    element = document.importNode template, true
    element.querySelector(".container-url").textContent = url
    wrapper = element.querySelector(".container-wrapper")

    removeButton = element.querySelector(".container-remove")
    refreshButton = element.querySelector(".container-refresh")

    if url == "defaults"
      removeButton.style.display = "none"
      refreshButton.style.display = "none"
    else
      removeButton.addEventListener "click", ->
        removeButton.style.color = "Red"
        if confirm "Are you sure you want to remove this these rules?"
          wrapper.style.display = "none"
          key = Common.getKey url
          chrome.storage.sync.get [ "network", key ], (items) ->
            unless chrome.runtime.lastError
              network = items.network.filter (str) -> str != url
              chrome.storage.sync.remove key, ->
                chrome.storage.sync.set { network }
        else
          removeButton.style.color = ""

      refreshButton.addEventListener "click", -> fetchUrl url

    for rule in rules
      do (rule) ->
        template = document.querySelector('#rule-template').content
        ele = document.importNode template, true
        ele.querySelector(".rule-name").textContent = rule.name or "Unknown Name"
        ele.querySelector(".rule-text").textContent = textify rule
        # ele.querySelector(".rule-enabled").checked = true
        ele.querySelector(".rule-show").value = "Show Details"

        do (ele) ->
          showing = false
          button = ele.querySelector(".rule-show")
          text = ele.querySelector(".rule-text")
          maintainState = ->
            if showing
              button.value = "Hide Details"
              text.style.display = ""
            else
              button.value = "Show Details"
              text.style.display = "none"

          maintainState()
          ele.querySelector(".rule-show").addEventListener "click", ->
            showing = not showing
            maintainState()

        wrapper.appendChild ele
    container.appendChild element

initialiseNetworkRules = ->
  chrome.storage.sync.get null, (items) ->
    network = $("network")
    network.removeChild network.firstChild while network.firstChild
    for url in items.network
      new RuleSet $("network"), url, items[Common.getKey url]

showMessage = do ->
  timer = null
  messageElement = null

  tween = ->
    clearTimeout timer if timer
    opacity = 1.0
    messageElement.style.opacity = opacity
    stepTween = ->
      opacity = opacity - 0.02
      messageElement.style.opacity = opacity
      timer = Common.setTimeout 10, stepTween if 0 < opacity
    timer = Common.setTimeout 3500, stepTween

  (msg) ->
    messageElement = $("fetch-message")
    messageElement.textContent = msg
    tween()

fetchUrl = (url) ->
  refreshingRules = "string" == typeof url

  unless refreshingRules
    urlElement = $("add-network-text")
    url = localStorage.previousUrl = urlElement.value.trim()

    if url.length == 0
      showMessage "Please enter a URL above."
      return

    if /\s/.test(url) or not /^https?:\/\/.*\//.test url
      showMessage "That doesn't look like a valid URL."
      return

  showMessage "Fetching #{url}..."
  Common.wget url, (response) ->
    { success, error, text, date } = response

    unless success
      error = "Unknown HTTP error" unless "string" == typeof error
      showMessage error
      return

    try
      configs = JSON.parse text
    catch
      showMessage "HTTP request succeeded, but failed to parse the resulting JSON."
      return

    try
      for config in configs
        config.name.length
        config.regexps.length
    catch
      showMessage "HTTP request succeeded and JSON parsed, but could not verify that all of the rules
        define names and regular expressions."
      return

    # Should be good to go, now.
    key = Common.getKey url
    chrome.storage.sync.get [ "network", key ], (items) ->
      if chrome.runtime.lastError
        showMessage "Yikes, an internal Chrome error occurred."
        return

      if Common.structurallyEqual configs, items[key]
        showMessage "Looks like the rules are unchanged."
        return

      items.network ?= []
      items.network.push url unless 0 <= items.network.indexOf url
      update = {}
      update.network = items.network
      key = Common.getKey url
      update[key] = configs
      chrome.storage.sync.set update, ->
        if chrome.runtime.lastError
          showMessage "Yikes, an internal Chrome error occurred."
          return

        if refreshingRules
          showMessage "Rules refreshed successfully for #{url}."
          initialiseNetworkRules()
        else if items[key]
          showMessage "These rules have been added previously; they've been refreshed now."
          initialiseNetworkRules()
        else
          chrome.storage.sync.get key, (items) ->
            unless chrome.runtime.lastError
              showMessage "Network rules added successfully."
              new RuleSet $("network"), url, items[key]

Common.documentReady ->
  chrome.storage.sync.get null, (items) ->
    $("manual-text").textContent = textify items.custom
    $("manual").style.display = "none"
    new RuleSet $("default"), "defaults", Common.default
    initialiseNetworkRules()

    localStorage.previousUrl ?= "http://smblott.org/jk-navigator-too.txt"
    urlElement = $("add-network-text")
    urlElement.value = localStorage.previousUrl

    messageElement = $("fetch-message")
    messageElement.style.opacity = "0.0"

    $("add-network-button").addEventListener "click", fetchUrl
    urlElement.addEventListener "keydown", (event) ->
      fetchUrl() if event.keyCode == 13

