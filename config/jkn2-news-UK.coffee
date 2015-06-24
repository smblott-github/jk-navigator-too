
configs = []

configs.push
  name: "BBC News"
  regexps: [
    "^https?://www\\.bbc\\.(com|co\\.uk)/news/?$"
    "^https?://www\\.bbc\\.(com|co\\.uk)/news/.+[^0-9?]$"
  ]
  selectors: [
    # "div.column--primary a[tabindex]"
    # This is better done with xPath, since then we can go up a level (which turns out to be the right thing
    # to do, here).
    "//a[@tabindex]/.."
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

require("../common.js").Common.mkConfigs configs, name: "UK News Sites"

