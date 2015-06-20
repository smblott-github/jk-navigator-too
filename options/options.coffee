
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

    if url == "defaults"
      element.querySelector(".container-remove").style.display = "none"
    else
      element.querySelector(".container-remove").addEventListener "click", ->
        if confirm "Are you sure you want to remove this these rules?"
          wrapper.style.display = "none"
          key = Common.getKey url
          chrome.storage.sync.get [ "network", key ], (items) ->
            unless chrome.runtime.lastError
              network = items.network.filter (str) -> str != url
              chrome.storage.sync.remove key, ->
                chrome.storage.sync.set { network }

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

Common.documentReady ->

  chrome.storage.sync.get null, (items) ->
    $("manual-text").textContent = textify items.custom

    for url in items.network
      new RuleSet $("network"), url, items[Common.getKey url]

    new RuleSet $("default"), "defaults", Common.default

    do ->
      localStorage.previousUrl ?= "http://smblott.org/jk-navigator-too.txt"
      urlElement = $("add-network-text")
      urlElement.value = localStorage.previousUrl

      messageElement = $("fetch-message")
      messageElement.style.opacity = "0.0"

      showMessage = do ->
        timer = null

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
          messageElement.textContent = msg
          tween()

      fetchUrl = ->
        url = urlElement.value.trim()
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

            items.network ?= []
            items.network.push url
            update = {}
            update.network = items.network
            key = Common.getKey url
            update[key] = configs
            chrome.storage.sync.set update, ->
              if chrome.runtime.lastError
                showMessage "Yikes, an internal Chrome error occurred."
                return


              if items[key]
                showMessage "Network rules updated."
                alert "That URL has been added previously.  Please refresh the page to see any updates."
                return

              chrome.storage.sync.get key, (items) ->
                unless chrome.runtime.lastError
                  showMessage "Network rules added successfully."
                  new RuleSet $("network"), url, items[key]

      $("add-network-button").addEventListener "click", fetchUrl
      urlElement.addEventListener "keydown", (event) ->
        fetchUrl() if event.keyCode == 13

