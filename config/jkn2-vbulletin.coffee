
configs = []

configs.push
  name: "Vbulletin Forum Display"
  regexps: "\\bforumdisplay\\.php\\?"
  selectors: "td[id^='td_threadtitle_']"
  offset: 150

configs.push
  name: "Vbulletin Thread"
  regexps: "\\bshowthread\\.php\\?"
  selectors: "td[id^='td_post_']"
  offset: 150

console.log JSON.stringify configs, null, "  "

