
configs = []
meta =
  name: "Irish News Sites"

configs.push
  name: "The Irish Times"
  regexps: "^http://www\\.irishtimes\\.com/?$"
  selectors: [
    "div#content_left_upper div.story"
    "div#content_left div.story"
  ]

configs.push
  name: "The Irish Independent"
  regexps: "^http://www\\.independent\\.ie/?"
  selectors: [
    "div.column.double article:not(.small) > a"
    "div.column.single div:not([data-minarticles]) article:not(.small) > a"
  ]

configs.push
  name: "The Journal IE Home Page"
  regexps: "^http://www\\.thejournal\\.ie/?$"
  selectors: "div.river.span-8 div.post"
  activators: "h4 a"
  offset: 20

process.stdout.write require("../common.js").Common.mkConfigs configs, meta

