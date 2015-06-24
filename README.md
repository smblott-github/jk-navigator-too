## JK-Navigator-Too

Available on the [Chrome Store](https://chrome.google.com/webstore/detail/jk-navigator-tooaakbjkmojammjfadiljkfkmfbbfc).

**Note**:  This is still a work in progress.  It works well in many cases (e.g.
Google, BBC News, Reddit), but there are quirks in others.

With JK-Navigator-Too (jkn2), you can bind logical movements to the `j` and `k` keys
(for example, to select search results on Google, or news stories on the BBC,
or Reddit posts, or whatever).

In addition, the `Enter` key activates the link associated with the selected
element.  Searching Google usually becomes something like `j-j-Enter`; browsing
Reddit: `j-Enter`, `j-Enter`.  You get the idea.

Here's a screenshot:

![Screenshot](https://cloud.githubusercontent.com/assets/2641335/8305814/691ad966-19aa-11e5-9ce5-fc83d0b00f2a.png)

#### Configuration

All jkn2 configuration is via rule sets on the web; there some examples [here](http://jkn2.smblott.org/).

A rule set is a JSON-encoded list of rules.  It's probably simplest just to look at an [example](http://jkn2.smblott.org/jkn2-search.txt):
- `configs` is the list of rules.
- `meta` is metadata describing the rule set.

You can create your own rule sets (or, perhaps just touch up the existing
ones).  See
[here](https://github.com/smblott-github/jk-navigator-too/tree/master/config)
and
[here](https://github.com/smblott-github/jk-navigator-too/blob/master/config/Makefile)
for workflow ideas.

##### Details: Metadata

The metadata consists of two properties: a (short) `name` and a slightly longer
`comment`.  These are both used (if present) on the options page.

##### Details: Rule Set

A rule set is a list of rules, with each rule having the following properties:

- **name**: (required) A short name. Example:

```
name: "Google Search"
```

- **regexps**: (required) Either a single string or a list of strings, each
  being a Javascript regular expression which is matched against the URL of the
  page. To match *all* pages, use `"."`.  Example:

```
regexps: "^https?://(www\.)?google\.([a-z\.]+)/search\?"
```

- **selectors** (kinda required) Again, either a single string or a list of
  strings, each being a CSS selector.  These are used to choose which elements
  within the page are selectable.

```
selectors: "div#search li.g"
```

- **activators** (optional) Again CSS selector(s), as above, but require only
  if the default method of finding the element to click when you type `Enter`
  doesn't work.  There are examples [here](http://jkn2.smblott.org/jkn2-social.txt).

- **style** (optional) A Javascript object whose properties are mixed into
  those of the overlay element highlighting the currently-selected element.
  For example, you can change the colour of the overlay:

```
style:
  "border-color": "#0266C8"
  opacity: "0.2"
```

- **priority** (optional)  (A smaller value is a higher priority.) Rules are
  sorted by priority (low to high).  First match wins.  Use this if a URL might
  match several rules.  However, without an explicit priority, rules within a
  single rule set retain the original ordering.

###### Advanced

- **native** (optional, boolean) Do not use `j`/`k` bindings, use the page's
  native bindings instead. `Enter` remains bound, so you can still hit `Enter`
  to activate the "currently-active element".

- **activeSelector** (optional) When using native `j`/`k` bindings (and the
  page does not set `document.activeElement`), these CSS selectors are used to
  find the active element for `Enter`.

