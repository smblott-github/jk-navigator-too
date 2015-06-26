
configs = []

configs.push
  name: "Youtube Search Results"
  regexps: "^https?://www\\.youtube\\.com/results\\?"
  selectors: "ol.item-section > li"
  activators: 'a[href^="/watch"]'
  offset: 80

require("../../common.js").Common.mkConfigs configs, name: "Youtube"

