
configs = []
meta =
  name: "SMBlott's Sites"
  comment: "This is unlikely to contain much of interest to anybody else."

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Steephill Photos"
  regexps: "^https?://www\\.steephill\\.tv/.*/photos/"
  selectors: "tr a[name] img"

process.stdout.write require("../common.js").Common.mkConfigs configs, meta

