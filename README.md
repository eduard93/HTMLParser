# HTMLParser
HTML Parser/selector on embedded python for InterSystems IRIS. Based on [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) and lxml.

Tested on: `IRIS for UNIX (Ubuntu Server LTS for x86-64 Containers) 2021.1.0PYTHON (Build 208U) Fri May 7 2021 18:41:46 UTC`

# Installation

1. Load and compile code.
2. Install modules: `set sc = ##class(dc.ed.html.Parser).install()`

# Usage

1. Create a parsed document from HTML text or URL: 
```
set doc = ##class(dc.ed.html.Parser).parse("https://google.com")`
```

`doc` is a data structure representing a parsed HTML or XML document.

2. Call `findall` / `select` methods (description below) to get a list of `Tag` objects.
3. Get data from the `Tag` object

## findall

The `findall` method looks through a tag’s descendants and retrieves all descendants that match your filters. [Docs](https://www.crummy.com/software/BeautifulSoup/bs4/doc/#find-all).

Arguments:

- name: Pass in a value for name and you’ll tell Beautiful Soup to only consider tags with certain names. Text strings will be ignored, as will tags whose names that don’t match. The value to name can be a string, a regular expression, a list, a function, or the value True.
- attrs: CSS class. OR A dictionary of filters on attribute values.
- recursive: If you call mytag.find_all(), Beautiful Soup will examine all the descendants of mytag: its children, its children’s children, and so on. If you only want to consider direct children, you can pass in recursive=False.
- string: With string you can search for strings instead of tags.  As with name and the keyword arguments, you can pass in a string, a regular expression, a list, a function, or the value True. 
- limit: `findall` returns all the tags and strings that match your filters.  This can take a while if the document is large. If you don’t need all the results, you can pass in a number for limit. This works just like the LIMIT keyword in SQL. It tells Beautiful Soup to stop gathering results after it’s found a certain number.

## select

Run a CSS selector against a parsed document or tag and return all the matching elements.
Docs: [1](https://www.crummy.com/software/BeautifulSoup/bs4/doc/#css-selectors), [2](https://facelessuser.github.io/soupsieve/selectors/)

Arguments:
- selector: CSS selector. Required
- namespaces: CSS anmespace.
- limit: `select` returns all the tags and strings that match your CSS selector. This can take a while if the document is large. If you don’t need all the results, you can pass in a number for limit. This works just like the LIMIT keyword in SQL. It tells Beautiful Soup to stop gathering results after it’s found a certain number.

# Tag object

Tag obect is one HTML tag. Several properties are exposed as read-only methods:

- name: Tag name. For example: div
- text: Visible text contained in this tag (includes children)
- attrs(attr): get `attr` attribute value

Notes:
- There's also a `display` utility method to output `name` and `text`.
- Python tag object is available as a `py` property.
- `Doc` object is also a `Tag`.

# Example

Get links from page:

```
set doc = ##class(dc.ed.html.Parser).parse("https://google.com")
set links = doc.findall("a")
for i=1:1:links.Count() { write links.GetAt(i).text(),$c(9),links.GetAt(i).attrs("href"),!}
```

Returns:
```
Images  https://www.google.com/imghp?hl=en&tab=wi
Maps    https://maps.google.com/maps?hl=en&tab=wl
Play    https://play.google.com/?hl=en&tab=w8
YouTube https://www.youtube.com/?gl=US&tab=w1
News    https://news.google.com/?tab=wn
Gmail   https://mail.google.com/mail/?tab=wm
Drive   https://drive.google.com/?tab=wo
More »  https://www.google.com/intl/en/about/products?tab=wh
Web History     http://www.google.com/history/optout?hl=en
Settings        /preferences?hl=en
Sign in https://accounts.google.com/ServiceLogin?hl=en&passive=true&continue=https://www.google.com/&ec=GAZAAQ
Advanced search /advanced_search?hl=en&authuser=0
Advertising Programs    /intl/en/ads/
Business Solutions      /services/
About Google    /intl/en/about.html
Privacy /intl/en/policies/privacy/
Terms   /intl/en/policies/terms/
```