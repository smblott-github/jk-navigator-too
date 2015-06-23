
configs = []
meta =
  name: "JK-Navigator-Too Extension Page"
  comment: "This allows smooth j/k scrolling on the extension's options page."

configs.push
  name: "JK-Navigator-Too Options Page"
  regexps: "^chrome-extension://.*/options/options.html"
  selectors: []

process.stdout.write require("../common.js").Common.mkConfigs configs, meta

