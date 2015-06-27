## JK-Navigator-Too

With JK-Navigator-Too (jkn2), you can use `j`/`k` to select elements on a number of popular web sites:
search results on Google, DuckDuckGo, Youtube, news stories and live reporting on the BBC or the Guardian,
posts on Reddit, and so on.

In addition, the `Enter` key activates the link associated with the selected
element.  The browsing experience is `j-Enter`, or `j-j-Enter`, or
whatever; no mouse required.

#### Getting Started

1. Install the [Chrome extension](https://chrome.google.com/webstore/detail/jk-navigator-tooaakbjkmojammjfadiljkfkmfbbfc).

1. Navigate to [here](http://jkn2.smblott.org/) and browse the available rule
   sets:  for example, [Google Search](http://jkn2.smblott.org/search/jkn2-google.txt),
   [DuckDuckGo](http://jkn2.smblott.org/search/jkn2-duckduckgo.txt),
   [Twitter](http://jkn2.smblott.org/search/jkn2-duckduckgo.txt),
   [Reddit](http://jkn2.smblott.org/social/jkn2-reddit.txt)
   or various [UK News sites](http://jkn2.smblott.org/news/jkn2-news-UK.txt).

1. With the extension installed, when you visit the configuration files above,
   a popup appears at the bottom right-hand side of the screen.  You can import
   the rule set by clicking "Yes please".

#### Screenshots

Here are some screenshots:

- [Google Search](https://cloud.githubusercontent.com/assets/2641335/8390527/c02f0716-1c90-11e5-83ee-3003241c09f8.png)
- [Reddit](https://cloud.githubusercontent.com/assets/2641335/8390547/43e6b9c8-1c91-11e5-80a4-3613488fa514.png)
- [BBC Live Reporting](https://cloud.githubusercontent.com/assets/2641335/8390555/8db98936-1c91-11e5-9a08-4e2e2ef524f6.png)
- [Github Issues](https://cloud.githubusercontent.com/assets/2641335/8390564/263da264-1c92-11e5-8925-89e084eabff7.png)

In each case, `j` selects the next item and `Enter` follows the associated link.

#### Why Another JK-Navigator?

There are several similar extensions or user scripts out there; so why another?

- The main reason: I don't like the UX of the alternatives.  They all have
  oddities whereby the usability just feels weird.

- Here, there's better separation of the *selected element* (which is
  highlighted with an overlay) and the *active link* (the one we follow when
  the user hits `Enter`).

- Here, we distribute rule-set configurations over the network and synchronise
  configuration between browser interfaces.  In other words, we're not typing
  JSON into an HTML input.

In some rule sets, we use the site's native `j`/`k` bindings (*hey, they work well*), but augment them
with `Enter`-to-activate-the-select-link; examples are the
[Facebook](http://jkn2.smblott.org/social/jkn2-facebook.txt) home page and [Google
Plus](http://jkn2.smblott.org/social/jkn2-google-plus.txt).  This gives a
consistent UX across a variety of sites.

#### Customisation

It is possible to write your own rule sets; however, unfortunately, the process
isn't yet properly documented.  If you're feeling brave, then take a look
[here](https://github.com/smblott-github/jk-navigator-too/tree/master/config)
and - in particular -
[here](https://github.com/smblott-github/jk-navigator-too/blob/master/config/Makefile).

New and improved rules sets are very welcome.  Please submit them as PRs here on github.
