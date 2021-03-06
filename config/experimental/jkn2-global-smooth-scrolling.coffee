
configs = []

configs.push
  name: "Smooth Scrolling On All Sites"
  regexps: "."
  selectors: []
  priority: 2000000

require("../../common.js").Common.mkConfigs configs,
  name: "Global Smooth Scrolling"
  comment:
    """
    This implements smooth scrolling on <i>all</i> sites (but has a low priority, so other rules are
    considered first). However, you should be aware that this also overrides the native j/k bindings on sites
    like GMail; hence, it's "experimental".
    """

