
configs = []

configs.push
  name: "JK-Navigator-Too Options Page"
  regexps: "^chrome-extension://.*/options/options.html"
  selectors: []

require("../../common.js").Common.mkConfigs configs,
  name: "JK-Navigator-Too Extension Page"
  comment:
    """
    This implements smooth j/k scrolling on the extension's own options page.
    """

