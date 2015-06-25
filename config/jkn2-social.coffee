
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

configs.push
  name: "Twitter"
  comment:
    """
    In addition to selecting tweets, this also selects the "New Tweets" button at the top of the page.  Scroll
    to the top and hit "Enter" to load new tweets.
    """
  regexps: "^https?://([a-z]+\\.)?twitter.com/?"
  selectors: do ->
    selectors = [ "div.new-tweets-bar" ]
    for context in [ "div.home-stream", "div.profile-stream", "div.list-stream" ]
      for content in [ "div.original-tweet", "li.conversation-root", "li.js-simple-tweet", "div.QuoteTweet" ]
        selectors.push "#{context} #{content}"
    selectors
  activators: [
    "div.original-tweet a.twitter-timeline-link"
    # "div.multi-photos"
    # View/Hide conversation (also view photo).
    "div.stream-item-footer span.expand-stream-item"
    "div.stream-item-footer span.collapse-stream-item"
  ]
  offset: 80

configs.push
  name: "Imgur Albums"
  comment:
    """
    Use j/k bindings to select photos in Imgur albums.
    """
  regexps: "^https?://([a-z]+\\.)?imgur.com/a/."
  selectors: "div#image-container > div.image"

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

require("../common.js").Common.mkConfigs configs,
  name: "Social Networks"
  comment: "Facebook, Twitter, Reddit, etc."

