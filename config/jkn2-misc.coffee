
configs = []
meta =
  name: "JK-Navigator-Too Extension Page"
  comment:
    """
    This allows smooth j/k scrolling on the extension's own options page (possibly this page). Try it!
    A similar trick can be used to enable smooth j/k scrolling on <i>any</i> page: use the regexp "<code>.</code>" and an empty list of selectors.
    """

configs.push
  name: "JK-Navigator-Too Options Page"
  regexps: "^chrome-extension://.*/options/options.html"
  selectors: []

process.stdout.write require("../common.js").Common.mkConfigs configs, meta

