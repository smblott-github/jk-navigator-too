
configs = []

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
    # "div.subnav-links a.subnav-item:not(.selected):not([data-selected-links^='repo_labels']):not([data-selected-links^='repo_milestones'])"
  ]
  activators: "a.issue-title-link"

configs.push
  name: "Github Discussions"
  regexps: "^https?://github.com/.*/(issues?|pulls?)/[0-9]+$"
  selectors: [
    "div.discussion-timeline div[id^='issue-']"
    "div.discussion-timeline div[id^='issuecomment-']"
    "div.discussion-timeline div[id^='commitcomment-']"
    "div.discussion-timeline div[id^='discussion-diff-']"
    "div.discussion-timeline div.commit-comment"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]
  activators: [
    # Prefer issue links.
    "div.comment-content a.issue-link"
    # Discourage user mentions.
    "div.comment-content a:not(.user-mention)"
    # Prefer other links within the comment itself.
    "div.comment-content a"
  ]

configs.push
  name: "Github Commits"
  regexps: "^https?://github.com/.*/commits$"
  selectors: [
    "div#commits_bucket li.js-navigation-item"
    # Navigation bar.
    # "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]
  activators: "a[href*='/commit/']"

require("../../common.js").Common.mkConfigs configs,
  name: "Github"
  comment:
    """
    Github provides its own keyboard bindings on some pages.  However, the bindings here offer a better (??)
    overall feel. (Well, that's my opinion.)
    """

