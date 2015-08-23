
configs = []

configs.push
  name: "Google Search"
  regexps: "^https?://(www\\.)?google\\.([a-z\\.]+)/search\\?"
  selectors: [
    "div#search li.g"
    # "div.srg div.g"
    "div.g > div.rc"
  ]
  style:
    "border-color": "#0266C8"
    opacity: "0.2"

require("../../common.js").Common.mkConfigs configs, name: "Google Search"

