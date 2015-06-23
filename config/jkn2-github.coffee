
configs = []

configs.push
  name: "Github Issues/Pulls/Notifications"
  priority: 1
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

configs.push
  name: "Github Discussions"
  priority: 2
  regexps: "^https?://github.com/.*/(issues?|pulls?)/[0-9]+$"
  selectors: [
    "div.discussion-timeline div[id^='issue-']"
    "div.discussion-timeline div[id^='issuecomment-']"
    "div.discussion-timeline div[id^='commitcomment-']"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]

configs.push
  name: "Github Commits"
  priority: 3
  regexps: "^https?://github.com/.*/commits$"
  selectors: [
    "div#commits_bucket li.js-navigation-item"
    # Navigation bar.
    "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
  ]

# This doesn't work well.  It's better without.
# configs.push
#   name: "Github Diffs"
#   regexps: [
#     "^https?://github.com/.*/pull/[0-9]+/files"
#   ]
#   selectors: [
#     "td.blob-code-addition"
#     "td.blob-code-deletion"
#     # Navigation bar.
#     "div.tabnav a.tabnav-tab:not(.selected):not(.preview-tab)"
#   ]

require("../common.js").Common.mkConfigs configs,
  name: "Github"
  comment: "Github provides its own keyboard bindings on some pages.  However, the bindings here offer a better (??) overall feel. (Well, that's my opinion.)"

