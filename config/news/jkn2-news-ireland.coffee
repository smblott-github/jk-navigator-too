
configs = []

configs.push
  name: "The Irish Times"
  regexps: "^http://www\\.irishtimes\\.com/?$"
  selectors: [
    "div#content_left_upper div.story"
    "div#content_left div.story"
    "div#content_left div.trending"
    "div#content_left ul.latest_news_index > li"
  ]
  offset: 70

configs.push
  name: "The Irish Independent Home Page"
  regexps: "^http://www\\.independent\\.ie/?$"
  selectors: [
    "div.column.double article:not(.small) > a"
    "div.column.single div:not([data-minarticles]) article:not(.small) > a"
  ]
  offset: 50

configs.push
  name: "The Journal IE Home Page"
  regexps: "^http://www\\.thejournal\\.ie/?$"
  selectors: "div.river.span-8 div.post"
  activators: "h4 a"

configs.push
  name: "The Journal IE Home Page"
  regexps: [
    "^http://www\\.broadsheet\\.ie/?$"
    "^http://www\\.broadsheet\\.ie/page/[0-9]+/?$"
  ]
  selectors: "div#primary div#content article.post"

require("../../common.js").Common.mkConfigs configs,
  name: "Irish News Sites"
  comment: "Bindings for various Irish news sites."

