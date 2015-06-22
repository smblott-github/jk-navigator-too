
configs = []

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  offset: 20
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Steephill Photos"
  regexps: "^https?://www\\.steephill\\.tv/.*/photos/"
  selectors: "tr a[name] img"
  offset: 20

console.log JSON.stringify configs, null, "  "

