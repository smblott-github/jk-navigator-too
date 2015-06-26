
configs = []

configs.push
  name: "Google Plus"
  comment:
    """
    This uses Google Plus' native j/k bindings (which work well), but adds the ability to activate the primary
    link on <code>Enter</code>.  By using the native bindings for j/k, we're able to also use Google's other
    bindings, such as o, n and p.
    """
  native: true
  regexps: "^https?://plus\\.google\\.com"
  # NOTE: This is pretty dodgy.  Google doesn't set activeElement.  Instead, we detect the active element via
  # its CSS.  Unfortunately, this looks like it's been through a minifier.  So it could easily change.
  activeSelector: "div.tk.va[id^=update-]"
  activators: [
    "div[role='button'][aria-label='Play'" # Launch videos.
    "a[target='_blank'][href^='http']:not([oid]):not([itemprop='map'])" # External links (but not maps).
    "a[href^='photos/']" # Photos.
  ]

require("../../common.js").Common.mkConfigs configs, name: "Google Plus"

