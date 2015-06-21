
configs = []

configs.push
  name: "Facebook Home Page (smblott)"
  regexps: "^https?://www\\.facebook\\.com/?$"
  selectors: "div[data-timestamp] > div.userContentWrapper"
  activators: [ "div.fbstoryattachmentimage img", "a[rel=theater]" ]
  style:
    "border-color": "#3b5998"
    opacity: "0.2"

configs.push
  name: "Irish Times Home Page"
  regexps: "^http://www\\.irishtimes\\.com/$"
  selectors: [
    "div#content_left_upper div.story"
    "div#content_left div.story"
  ]

configs.push
  name: "Irish Times Article"
  regexps: "^http://www\\.irishtimes\\.com/."
  selectors: 'section[property="articleBody"] > p'
  style:
    opacity: "0.2"

configs.push
  name: "Intent Radio"
  regexps: "^http://intent-radio\\.smblott\\.org/"
  selectors: "a"

configs.push
  name: "The Journal IE"
  regexps: "^http://www\\.thejournal\\.ie/?$"
  selectors: "div.river.span-8 div.post"
  activators: "h4 a"

configs.push
  name: "The Journal IE Article"
  regexps: "^http://www\\.thejournal\\.ie/."
  selectors: [
    "span#articleContent p"
    "span#articleContent blockquote"
    "ul.commentList li div.comment"
    "iframe[id^='twitter-widget']"
  ]
  style:
    opacity: "0.2"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  offset: 20
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Vbulletin Forum Display"
  regexps: "\\bforumdisplay\\.php\\?f(orumid)?="
  selectors: "td[id^='td_threadtitle_']"
  offset: 150

configs.push
  name: "Vbulletin Thread"
  regexps: "\\bshowthread\\.php\\?(t|p)="
  selectors: "td[id^='td_post_']"
  offset: 150

configs.push
  name: "Steephill Photos"
  regexps: "^https?://www\\.steephill\\.tv/.*/photos/"
  selectors: "tr a[name] img"
  offset: 20

configs.push
  name: "Reddit"
  regexps: "^http://www\\.reddit\\.com/?"
  selectors: "div.entry > p.title > a"
  offset: 20

configs.push
  name: "Twitter"
  regexps: "^https?://([a-z]+\\.)?twitter.com/?"
  selectors: [
    "div.home-stream div.content"
    "div.profile-stream div.content"
    "div.list-stream div.content"
  ]
  offset: 80

configs.push
  name: "Google Plus"
  regexps: "^https?://plus\\.google\\.com"
  selectors: [ "div[id^='update-']" ]
  offset: 80
  style:
    "border-color": "#0266C8"
    opacity: "0.2"

console.log JSON.stringify configs, null, "  "

