
configs = []

configs.push
  name: "Facebook Home Page"
  comment:
    """
    This uses Facebook's native j/k bindings on the Facebook home page (which work well), but adds the ability
    to activate the primary link on <code>Enter</code>.  By using the native bindings for j/k, we're able to
    retain Facebook's "l" binding for "like".
    """
  regexps: "^https?://www\\.facebook\\.com/?$"
  native: true
  # These selectors are good (15/6/24).  They're just not needed if we're using the native j/k/ bindings.
  # selectors: [
  #   # CSS version.
  #   # "div[data-timestamp] > div.userContentWrapper"
  #   # xPath version (this allows us to select the parent).
  #   "//div[@data-timestamp]/div[contains(@class,'userContentWrapper')]/.."
  # ]
  activators: [ "div.fbstoryattachmentimage img", "a[rel=theater]" ]
  activeSelector: "div[tabindex='0'] > div.userContentWrapper"
  offset: 65
  style:
    "border-color": "#3b5998"
    opacity: "0.2"

configs.push
  name: "Facebook"
  comment:
    """
    This adds j/k bindings to Facebook pages <i>other than</i> the home page.
    """
  regexps: "^https?://www\\.facebook\\.com/."
  selectors: [
    # CSS version.
    # "div#content div.userContentWrapper"
    # xPath version (this allows us to select the parent).
    "//div[@id='content']//div[contains(@class,'userContentWrapper')]/.."
  ]
  activators: [
    "div.fbstoryattachmentimage img",
    "a[rel=theater]"
    "i > input[type='button']"
  ]
  offset: 100
  style:
    "border-color": "#3b5998"
    opacity: "0.2"

require("../../common.js").Common.mkConfigs configs, name: "Facebook"

