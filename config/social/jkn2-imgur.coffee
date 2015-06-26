
configs = []


configs.push
  name: "Imgur Albums"
  comment:
    """
    Use j/k bindings to select photos in Imgur albums.
    """
  regexps: "^https?://([a-z]+\\.)?imgur.com/a/."
  selectors: "div#image-container > div.image"

require("../../common.js").Common.mkConfigs configs, name: "Imgur Albums"

