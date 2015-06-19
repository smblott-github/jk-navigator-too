
configs = []

configs.push
  name: "Youtube Search Results"
  regexps: "^https?://www\\.youtube\\.com/results\\?."
  selectors: "ol.item-section > li"

configs.push
  name: "Irish Times Article"
  regexps: "^http://www\\.irishtimes\\.com/."
  selectors: 'section[property="articleBody"] > p'

configs.push
  name: "Irish Times Home Page"
  regexps: "^http://www\\.irishtimes\\.com/$"
  selectors: [
    "div.story.clearfix"
    "div.story.index_story"
    "div.feature_box"
    "row.section.news-package.news"
    "div.firstrow div.story"
  ]

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "The Journal IE"
  regexps: "^http://www\\.thejournal\\.ie/$"
  selectors: "div.river.span-8 div.post"
  activators: "h4 a"

configs.push
  name: "The Journal IE Article"
  regexps: "^http://www\\.thejournal\\.ie/."
  selectors: [ "span#articleContent p", "ul.commentList div.comment" ]

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  color: "#55B4CF"
  offset: 20

console.log JSON.stringify configs

