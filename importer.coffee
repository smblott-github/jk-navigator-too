
Importer =
  init: ->
    if /\/jkn2-[^/]+\.txt$/.test document.location.pathname
      console.log "jk-navigator-too: path appears to be config file."

      try
        { configs, meta } = JSON.parse document.body.textContent
      catch
        console.log "jk-navigator-too: cannot parse JSON."
        return

      unless configs?.length?
        console.log "jk-navigator-too: cannot find configs content."
        return

      unless configs?.length? and meta?.name
        console.log "jk-navigator-too: cannot find name meta data."
        return

      try
        for config in configs
          unless config.regexps and config.name
            console.log "jk-navigator-too: config appears invalid."
            return
      catch
        console.log "jk-navigator-too: failed to read config."
        return

      chrome.storage.sync.get "network", (items) =>
        unless chrome.runtime.lastError
          url = document.location.toString()
          if url in items.network
            @offerUpdate url
          else
            @offerInstall url

  offerInstall: (url) ->
    message =
      """
      This looks like a JK-Navigator-Too configuration file.
      <br/>
      Do you want to install it?
      """
    @offer message, =>
      @launch "install", url

  offerUpdate: (url) ->
    message =
      """
      This looks like a JK-Navigator-Too configuration file and it's already installed.
      <br/>
      Do you want to update it?
      """
    @offer message, =>
      @launch "update", url

  launch: (param, url) ->
    url = encodeURIComponent url
    chrome.runtime.sendMessage
      name: "open"
      url: chrome.extension.getURL "/options/options.html?#{param}=#{url}"
      sameTab: true

  offer: (message, callback) ->
    overlay = document.createElement "div"
    overlay.id = "JK-Navigator-Too-Overlay-Offer"
    document.body.appendChild overlay

    overlay = document.getElementById "JK-Navigator-Too-Overlay-Offer"
    Common.extend overlay.style,
      position: "fixed"
      left: innerWidth - 430
      top: innerHeight - 180
      width: 400
      height: 150
      overflow: "hidden"
      margin: "5px"

      "border-radius": "4px"
      "overflow": "scroll"
      "border-style": "solid"
      "border-color": "#666666"
      "border-width": "1px"
      "background-color": "#f5f5f5"

    overlay.innerHTML =
      """
      <p>
        #{message}
      </p>
      <p>
        <input type="button" id="JK-Navigator-Too-Overlay-button" value="Yes please." />
      </p>
      """

    button = document.getElementById "JK-Navigator-Too-Overlay-button"
    Common.extend button.style,
      float: "right"
      margin: "5px"

    button.addEventListener "click", ->
      overlay.parentElement.removeChild overlay
      callback?()

Common.documentReady ->
  Importer.init()

