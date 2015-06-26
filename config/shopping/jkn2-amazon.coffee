
configs = []

configs.push
  name: "Amazon Search"
  regexps: "^https?://www\\.amazon\\.[^/]+/s/"
  selectors: "div#resultsCol li[id^='result_']"

require("../../common.js").Common.mkConfigs configs, name: "Amazon Search Results"

