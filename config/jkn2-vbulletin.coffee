
configs = []

configs.push
  name: "Vbulletin Forum Display"
  regexps: "\\bforumdisplay\\.php\\?"
  selectors: "td[id^='td_threadtitle_']"
  activators: [
    "a[href^='showthread.php?goto']"
    "a[href^='showthread.php']"
  ]

configs.push
  name: "Vbulletin Thread"
  regexps: "\\bshowthread\\.php\\?"
  selectors: "td[id^='td_post_']"

require("../common.js").Common.mkConfigs configs,
  name: "VBulletin"
  comment: "Experimental support for vbulletin-based sites."

