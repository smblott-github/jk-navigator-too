
configs = []

configs.push
  name: "Irish Times Home Page"
  regexps: "^http://www\\.irishtimes\\.com/$"
  selectors: [
    "div#content_left_upper div.story"
    "div#content_left div.story"
  ]

configs.push
  name: "Irish Times Article"
  regexps: "^http://www\\.irishtimes\\.com/."
  selectors: 'section[property="articleBody"] > p'
  style:
    opacity: "0.2"

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

