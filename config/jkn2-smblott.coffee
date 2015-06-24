
configs = []

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "div#webcam > a > img"
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Steephill Photos"
  regexps: "^https?://www\\.steephill\\.tv/.*/photos/"
  selectors: "tr a[name] img"

configs.push
  name: "Weather in La Fouly"
  regexps: "http://www.meteoschweiz.admin.ch/home.html?"
  selectors: "section.forecast-local"

configs.push
  name: "Cycling News Live"
  regexps: "https?://live.cyclingnews.com/?"
  selectors: "ol#liveReportConsolePreview > li[id^='entry-']"

require("../common.js").Common.mkConfigs configs,
  name: "SMBlott's Sites"
  comment: "This is unlikely to contain much of interest to anybody else."

