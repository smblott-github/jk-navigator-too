
$ = (id) -> document.getElementById id
showMessage = null

textify = (text) ->
  text = JSON.stringify(text, null, 2)
  text = text.replace /^\[\]/, "[\n]"
  text = text.replace /},\n  {/g, "},\n\n  {"
  text

refreshers = []

class RuleSet
  constructor: (container, url, configs, lastUpdated = "on installation") ->
    rules = Common.getRules configs
    template = document.querySelector('#container-template').content
    element = document.importNode template, true
    element.querySelector(".container-url").textContent = url
    element.querySelector(".container-last-updated").textContent = lastUpdated
    wrapper = element.querySelector(".container-wrapper")
    ruleList = element.querySelector(".rule-list")

    removeButton = element.querySelector(".container-remove")
    refreshButton = element.querySelector(".container-refresh")
    showButton = element.querySelector(".container-show")

    removeButton.addEventListener "click", ->
      removeButton.blur()
      removeButton.style.color = "Red"
      if confirm "Are you sure you want to remove this these rules?"
        wrapper.style.display = "none"
        key = Common.getKey url
        chrome.storage.sync.get [ "network", key ], (items) ->
          unless chrome.runtime.lastError
            network = items.network.filter (str) -> str != url
            chrome.storage.sync.remove key, ->
              chrome.storage.sync.set { network }
              showMessage "Removed URL: #{url}"
      else
        removeButton.style.color = ""

    do ->
      key = Common.getShowKey url
      chrome.storage.local.get key, (items) ->
        unless items[key]?
          items[key] ?= false
          chrome.storage.local.set items

        maintainShowState = ->
          if items[key]
            ruleList.style.display = ""
            showButton.value = "Hide Rules"
          else
            ruleList.style.display = "none"
            showButton.value = "Show Rules"

        showButton.addEventListener "click", ->
          showButton.blur()
          items[key] = not items[key]
          chrome.storage.local.set items
          maintainShowState()
        maintainShowState()

    refresh = -> fetchUrl url
    refreshButton.addEventListener "click", ->
      refreshButton.blur()
      refresh()
    refreshers.push refresh

    element.querySelector(".rule-count").textContent =
      "#{rules.length} rule#{if rules.length == 1 then "" else "s"}"

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
          ruleShow = ele.querySelector(".rule-show")
          ruleShow.addEventListener "click", ->
            ruleShow.blur()
            showing = not showing
            maintainState()

        ruleList.appendChild ele
    container.appendChild element

initialiseNetworkRules = (callback) ->
  chrome.storage.sync.get null, (items) ->
    network = $("network")
    network.removeChild network.firstChild while network.firstChild
    for url in items.network
      new RuleSet $("network"), url, items[Common.getKey url], items[Common.getSuccessKey url]
    callback?()

class Tween
  constructor: (options) ->
    @element = options.element
    @delay = options.delay ? 6000
    @fade= options.fade ? 0.02
    @opacity 0.0
    @timer = null

  show: ->
    clearTimeout @timer if @timer
    @opacity opacity = 1.0

    step = =>
      @opacity opacity -= @fade
      @timer = Common.setTimeout 10, step if 0.0 < opacity
    @timer = Common.setTimeout @delay, step

  opacity: (opacity) ->
    @element.style.opacity =opacity

Common.documentReady ->
  showMessage = do ->
    messageElement = $("messages")
    tween = new Tween element: messageElement

    (msg) ->
      template = document.querySelector('#message-template').content
      element = document.importNode template, true
      element.querySelector(".message-container").textContent = msg
      messageElement.appendChild element
      messageElement.scrollTop = messageElement.scrollHeight
      tween.show()

fetchUrl = (url) ->
  refreshingRules = "string" == typeof url

  unless refreshingRules
    urlElement = $("add-network-text")
    url = localStorage.previousUrl = urlElement.value.trim()

    if url.length == 0
      showMessage "Please enter a URL in the box."
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
      for config in Common.getRules configs
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
        showMessage "...#{url} hasn't unchanged."
        return

      items.network ?= []
      items.network.push url unless 0 <= items.network.indexOf url
      update = {}
      update.network = items.network
      key = Common.getKey url
      successKey = Common.getSuccessKey url
      update[key] = configs
      update[successKey] = "#{new Date().toLocaleDateString()}, #{new Date().toLocaleTimeString()}"
      chrome.storage.sync.set update, ->
        if chrome.runtime.lastError
          showMessage "Yikes, an internal Chrome error occurred."
          return

        # Delay just a little bit in the hope that, if there are many messages, then this one ends up at the
        # bottom of the list.
        Common.setTimeout 100, ->
          if refreshingRules
            showMessage "Rules refreshed: #{url}."
            initialiseNetworkRules()
          else if items[key]
            showMessage "Rules refreshed: #{url}."
            initialiseNetworkRules()
          else
            chrome.storage.sync.get [ key, successKey ], (items) ->
              showMessage "...#{url} added successfully."
              new RuleSet $("network"), url, items[key], items[successKey]

Common.documentReady ->
  chrome.storage.sync.get null, (items) ->
    localStorage.previousUrl ?= "http://smblott.org/jknt-smblott.txt"
    urlElement = $("add-network-text")
    urlElement.value = localStorage.previousUrl

    addButton = $("add-network-button")
    addButton.addEventListener "click", ->
      addButton.blur()
      fetchUrl()
    urlElement.addEventListener "keydown", (event) ->
      fetchUrl() if event.keyCode == 13

    initialiseNetworkRules ->
      url = document.location.toString()
      if /[?&]refresh\b/.test url
        callback() for callback in refreshers

