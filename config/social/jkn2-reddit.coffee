
configs = []

configs.push
  name: "Reddit Comments"
  comment:
    """
    We select comments, but not responses.  This avoids the need to "j" through endless lists of drivel.
    """
  regexps: "^http://[a-z]+\\.reddit\\.com/.*/comments/"
  selectors: [
    "div#siteTable div.usertext-body"
    "div.commentarea > div.sitetable > div.comment"
  ]
  activators: "a[href^='http']:not(.author):not(.bylink)"

configs.push
  name: "Reddit"
  regexps: "^http://[a-z]+\\.reddit\\.com/?"
  selectors: "div.entry > p.title > a"


require("../../common.js").Common.mkConfigs configs, name: "Reddit"

