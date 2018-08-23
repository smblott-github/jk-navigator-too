
configs = []

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
    # for context in [ "div.home-stream", "div.profile-stream", "div.list-stream", "div.search-stream", "li.stream-item" ]
    for context in [ "li.stream-item" ]
      for content in [ "div.original-tweet", "li.conversation-root", "li.js-simple-tweet", "div.QuoteTweet" ]
        selectors.push "#{context} #{content}"
    selectors.push "div.self-thread-head"
    selectors.push "li.missing-tweets-bar"
    selectors
  activators: [
    "a.js-openLink"
    "div.tweet"
    "a.show-thread-link"
    "div.original-tweet a.twitter-timeline-link"
    "div.stream-item-footer span.expand-stream-item"
    "div.stream-item-footer span.collapse-stream-item"
  ]
  offset: 70

require("../../common.js").Common.mkConfigs configs, name: "Twitter"

