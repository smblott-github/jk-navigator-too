
configs = []

configs.push
  name: "Youtube Home Page"
  regexps: "^https?://([a-z]+\\.)?youtube.com/?$"
  selectors: "//a[contains(@href,'/watch?')]/div/img/../../../../.."
  activateSelectors: "a[href=^'/watch']"
  offset: 120

configs.push
  name: "Youtube Collections"
  regexps: [
    "^https?://([a-z]+\\.)?youtube.com/(playlist|channel)/"
    "^https?://([a-z]+\\.)?youtube.com/playlist\\?"
  ]
  selectors: [
    "li.channels-content-item"
    "li.featured-content-item"
    "li.expanded-shelf-content-item-wrapper"
    "tr.pl-video"
    "div.lohp-shelf-content > div.lohp-large-shelf-container"
    "div.lohp-shelf-content > div.lohp-medium-shelves-container > div.lohp-medium-shelf"
  ]
  activateSelectors: "a[href=^'/watch']"
  offset: 121

require("../../common.js").Common.mkConfigs configs, name: "Youtube"

