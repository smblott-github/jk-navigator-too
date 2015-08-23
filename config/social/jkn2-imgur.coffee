
configs = []

configs.push
  name: "Imgur Albums and Galleries"
  comment:
    """
    Use j/k bindings to select photos in Imgur albums.
    """
  regexps: [
    "^https?://([a-z]+\\.)?imgur.com/(a|gallery)/."
    # "^https?://([a-z]+\\.)?imgur.com/[a-zA-Z1-9]+$"
  ]
  selectors: [
    "div#image-container > div.image"
    "div#image > div.album-image"
    # "div#image > div.image"
  ]

require("../../common.js").Common.mkConfigs configs, name: "Imgur Albums"

