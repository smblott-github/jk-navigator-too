## JK-Navigator-Too

This is a work in progress.  It's a variation on
[jk-navigator](https://chrome.google.com/webstore/detail/jk-shortcuts-navigator/chgfodomgimhbcmlfljhkgildehakgif?hl=en),
but it's not yet ready for prime time.

### Configuration

(Also a work in progress.)

    {
      name: "google search"
      regexps: "^https?://(www\\.)?google\\.([a-z\\.]+)/search\\?"
      selectors: [ "li.g h3.r a", "a._eu._h2" ]
    }

    name:
      For documentation only

    regexp:
      Either a string or an array of strings, each a Jacascript regular
      expression identifying the URLs to which this definition applies.

    selectors:
      Either a string or an array of strings, each a CSS selector identifying
      the logical entities to which j/k should scroll.

    activators:
      Either a string or an array of strings, each a CSS selector identifying
      the element which should be "clicked" when the user types <Enter>.

    color:
      The CSS background colour to apply to the selected element.

