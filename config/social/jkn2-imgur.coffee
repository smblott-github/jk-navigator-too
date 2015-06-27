
configs = []


configs.push
  name: "Imgur Albums and Galleries"
  comment:
    """
    Use j/k bindings to select photos in Imgur albums.
    """
  regexps: "^https?://([a-z]+\\.)?imgur.com/(a|gallery)/."
  selectors: [
    "div#image-container > div.image"
    "div#image > div.album-image"
  ]

require("../../common.js").Common.mkConfigs configs, name: "Imgur Albums"

