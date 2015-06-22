
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

console.log JSON.stringify configs, null, "  "

