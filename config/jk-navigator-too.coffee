
configs = []

configs.push
  regexps: "^http://www.irishtimes.com/$"
  selectors: [ "div.story.clearfix", "div.story.index_story" ]

configs.push
  regexps: "^http://intent-radio.smblott.org/"
  selectors: "a"

configs.push
  regexps: "^http://www.thejournal.ie/$"
  selectors: "div.river.span-8 div.post"

console.log JSON.stringify configs

