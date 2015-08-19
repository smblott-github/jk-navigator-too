
configs = []

configs.push
  name: "Instagram Home Page"
  regexps: "^https?://([a-z]+\\.)?instagram.com/?$"
  selectors: "div > article"
  # activateSelectors: "a[href=^'/watch']"

require("../../common.js").Common.mkConfigs configs, name: "Instagram"

