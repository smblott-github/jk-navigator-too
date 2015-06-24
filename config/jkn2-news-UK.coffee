
configs = []

configs.push
  name: "BBC News"
  regexps: [
    "^https?://www\\.bbc\\.(com|co\\.uk)/news/?$"
    "^https?://www\\.bbc\\.(com|co\\.uk)/news/.+[^0-9?]$"
  ]
  selectors: [
    "div.column--primary a[tabindex]"
    "div.vertical-promo a.bold-image-promo"
    "div#comp-digest-2 div[data-entityid^='more-from-bbc-news']"
    "div.correspondent-promo div.correspondent-promo__correspondent"
  ]
  style:
    "z-index": 2000000000

configs.push
  name: "Smooth Scrolling On Other BBC News Pages"
  regexps: "^https?://www\\.bbc\\.(com|co\\.uk)/news"
  selectors: []
  priority: 1000000

configs.push
  name: "The Guardian"
  regexps: "^https?://www\\.theguardian\\.com(/?|/[a-z]+|/[a-z]+/[a-z]+)$"
  selectors: [
    "div.fc-item__container"
    "button.button--show-more"
  ]

configs.push
  name: "Smooth Scrolling on Other Guardian Pages"
  regexps: "^https?://www\\.theguardian\\.com/."
  selectors: []
  priority: 1000000

require("../common.js").Common.mkConfigs configs, name: "UK News Sites"

