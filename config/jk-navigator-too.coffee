
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
    "div#content_left_upper div.homepagetopspot"
    "div#content_left_upper div.story.clearfix"
    "div#content_left_upper div.story.index_story"
    "div#content_left_upper div.feature_box"
    "div#content_left_upper row.section.news-package.news"
    "div#content_left_upper div.firstrow div.story"
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
  selectors: [ "span#articleContent p", "span#articleContent blockquote", "ul.commentList li div.comment" ]
  style:
    opacity: "0.2"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  color: "#55B4CF"
  offset: 20

console.log JSON.stringify configs

