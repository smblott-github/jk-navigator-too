
configs = []
meta =
  name: "Search Engines"

configs.push
  name: "Google Search"
  regexps: "^https?://(www\\.)?google\\.([a-z\\.]+)/search\\?"
  selectors: "div#search li.g"
  offset: "50"
  style:
    "border-color": "#0266C8"
    opacity: "0.2"

configs.push
  name: "DuckDuckGo Search"
  regexps: "^https://duckduckgo\\.com/\\?"
  selectors: [
    "div#links div.result__body"
    "div#zero_click_wrapper div.zci__main div.zci__body"
  ]
  offset: "50"
  style:
    "z-index": 2000000000

configs.push
  name: "Youtube Search Results"
  regexps: "^https?://www\\.youtube\\.com/results\\?"
  selectors: "ol.item-section > li"
  activators: 'a[href^="/watch"]'

process.stdout.write require("../common.js").Common.mkConfigs configs, meta

