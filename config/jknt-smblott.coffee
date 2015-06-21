
configs = []

# configs.push
#   name: "Facebook Home Page (smblott)"
#   regexps: "^https?://www\\.facebook\\.com/?$"
#   selectors: "div[data-timestamp] > div.userContentWrapper"
#   activators: [ "div.fbstoryattachmentimage img", "a[rel=theater]" ]
#   style:
#     "border-color": "#3b5998"
#     opacity: "0.2"

configs.push
  name: "Facebook"
  regexps: "^https?://www\\.facebook\\.com/."
  selectors: [
    "div#content div.userContentWrapper"
  ]
  activators: [
    "div.fbstoryattachmentimage img",
    "a[rel=theater]"
    "i > input[type='button']"
  ]
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
  name: "The Journal IE Home Page"
  regexps: "^http://www\\.thejournal\\.ie/?$"
  selectors: "div.river.span-8 div.post"
  activators: "h4 a"
  offset: 20

configs.push
  name: "BBC News"
  regexps: "^https?://www\\.bbc\\.(com|co.uk)/news/\\?$"
  regexps: "^https?://www\\.bbc\\.(com|co.uk)/news/.*[^0-9]$"
  selectors: [
    "div.column--primary a[tabindex]"
    # "div.column--primary div[data-entityid^='container-top-stories']"
    # "div.column--primary div[data-entityid^='av-stories-now']"
    # "div.column--primary div[data-entityid^='feature-main']"
    # "div.column--primary div[data-entityid^='explainers']"
    # "div.column--primary div[data-entityid^='cluster_2']"
    # "div.column--primary div[data-entityid^='also-in-news']"
    # "div.column--primary div[data-entityid^='the_reporters']"
  ]
  offset: 20
  style:
    "z-index": 2000000000

# configs.push
#   name: "The Journal IE Article"
#   regexps: "^http://www\\.thejournal\\.ie/."
#   selectors: [
#     "span#articleContent p"
#     "span#articleContent blockquote"
#     "ul.commentList li div.comment"
#     "iframe[id^='twitter-widget']"
#   ]
#   style:
#     opacity: "0.2"

configs.push
  name: "La Fouly Webcam"
  regexps: "^http://www\\.telelafouly\\.ch/[a-z]+/webcam"
  selectors: "a.cboxElement img"
  offset: 20
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Vbulletin Forum Display"
  regexps: "\\bforumdisplay\\.php\\?"
  selectors: "td[id^='td_threadtitle_']"
  offset: 150

configs.push
  name: "Vbulletin Thread"
  regexps: "\\bshowthread\\.php\\?"
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
    "div.new-tweets-bar"
  ]
  offset: 80
  style:
    "border-color": "#55B4CF"

configs.push
  name: "Github Issues/Pulls/Notifications"
  regexps: [
    "^https?://github.com/.*/(issues|pulls)($|\\?)"
    "^https?://github.com/notifications"
    "^https?://github.com/.*/notifications"
  ]
  selectors: [
    "li.js-navigation-item"
    "div.pagination a.next_page"
    "div.subnav-links a.subnav-item:not(.selected):not([data-selected-links^='repo_labels']):not([data-selected-links^='repo_milestones'])"
  ]
  activators: "a.issue-title-link"
  offset: 30

configs.push
  name: "Github Discussions"
  regexps: [
    "^https?://github.com/.*/(issues?|pulls?)/[0-9]+$"
  ]
  selectors: [
    "div.discussion-timeline div[id^='issue-']"
    "div.discussion-timeline div[id^='issuecomment-']"
    "div.discussion-timeline div[id^='commitcomment-']"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]
  offset: 30

configs.push
  name: "Github Commits"
  regexps: [
    "^https?://github.com/.*/commits$"
  ]
  selectors: [
    "div#commits_bucket li.js-navigation-item"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]
  offset: 30

configs.push
  name: "Github Diffs"
  regexps: [
    "^https?://github.com/.*/pull/[0-9]+/files"
  ]
  selectors: [
    "td.blob-code-addition"
    "td.blob-code-deletion"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]
  offset: 250

# configs.push
#   name: "Google Plus"
#   regexps: "^https?://plus\\.google\\.com"
#   # selectors: [ "div[id^='update-']" ]
#   activators: [
#     # This needs more work.
#     "div[role='button']:not([g:token])" # Launch videos.
#     "a[target='_blank'][href^='http']:not([oid]):not([itemprop='map'])" # External links (but not maps).
#     "a[href^='photos/']" # Photos.
#   ]
#   offset: 80
#   nativeJK: true
#   style:
#     "border-color": "#0266C8"
#     opacity: "0.2"

console.log JSON.stringify configs, null, "  "

