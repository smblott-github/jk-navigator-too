
configs = []

configs.push
  name: "DuckDuckGo Search"
  regexps: "^https://duckduckgo\\.com/\\?"
  selectors: [
    "div#links div.result__body"
    "div#zero_click_wrapper div.zci__main div.zci__body"
  ]
  style:
    "z-index": 2000000000

require("../../common.js").Common.mkConfigs configs, name: "DuckDuckGo"

