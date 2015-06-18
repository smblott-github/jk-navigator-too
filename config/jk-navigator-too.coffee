
configs = []

configs.push
  name: "Irish Times Home Page"
  regexps: "^http://www\\.irishtimes\\.com/$"
  selectors: [ "div.story.clearfix", "div.story.index_story" ]

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "The Journal IE"
  regexps: "^http://www\\.thejournal\\.ie/$"
  selectors: "div.river.span-8 div.post"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://telelafouly\\.ch/.*/webcam$"
  selectors: "a.cboxElement img"

console.log JSON.stringify configs

