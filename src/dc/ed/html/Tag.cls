/// Represents an HTML or XML tag that is part of a parse tree, along with its attributes and contents
Class dc.ed.html.Tag Extends %RegisteredObject
{

/// Tag name. For example: div
Method name() As %String [ Language = python ]
{
	return self.py.name
}

/// Visible text contained in this tag (includes children)
Method text() As %String [ Language = python ]
{
	return self.py.text
}

/// Tag attribules
Method attrs(attr As %String) [ Language = python ]
{
	value = self.py.attrs.get(attr, None)
	if (type(value) is list) and (len(value)==1):
		value = value[0]
	return value
}

Method display()
{
	write "Tag:  ", ..name(),!
	write "Text: ", ..text(),!
	write "______",!
}

/// Python reference
Property py As %SYS.Python;

/// The find_all() method looks through a tag’s descendants and retrieves all descendants that match your filters. 
/// Docs: https://www.crummy.com/software/BeautifulSoup/bs4/doc/#find-all
/// Args:
///   - name: Pass in a value for name and you’ll tell Beautiful Soup to only consider tags with certain names. 
///           Text strings will be ignored, as will tags whose names that don’t match.
///           the value to name can be a string, a regular expression, a list, a function, or the value True.
///   - attrs: CSS class. OR A dictionary of filters on attribute values.
///   - recursive: If you call mytag.find_all(), Beautiful Soup will examine all the descendants of mytag: 
///                its children, its children’s children, and so on. 
///                If you only want Beautiful Soup to consider direct children, you can pass in recursive=False.
///   - string: With string you can search for strings instead of tags. 
///             As with name and the keyword arguments, you can pass in a string, a regular expression, a list, a function, or the value True. 
///   - limit: find_all() returns all the tags and strings that match your filters. 
///            This can take a while if the document is large. If you don’t need all the results, you can pass in a number for limit.
///            This works just like the LIMIT keyword in SQL. It tells Beautiful Soup to stop gathering results after it’s found a certain number.
/// 
/// Py sig: def find_all(self, name=None, attrs={}, recursive=True, text=None, limit=None, **kwargs):
Method findall(name As %String = {##class(%SYS.Python).None()}, attrs As %String = {##class(%SYS.Python).None()}, recursive As %Boolean = {##class(%SYS.Python).True()}, string As %String = {##class(%SYS.Python).None()}, limit As %Integer = {##class(%SYS.Python).None()}) As %ListOfObjects(CLASSNAME="dc.ed.html.Tag") [ CodeMode = expression ]
{
..findallint(name, attrs, recursive, string, limit)
}

/// Internal method, call findall instead as it provides default values
Method findallint(name, attrs, recursive, string, limit) [ Internal, Language = python ]
{
	import iris
	tags = iris.cls("%ListOfObjects")._New()
	for tag in self.py.find_all(name, attrs, recursive, string, limit):
	    tags.Insert(iris.cls("dc.ed.html.Tag")._New(tag))
	return tags
}

/// Run a CSS selector against a parsed document or tag and return all the matching elements.
/// Docs: https://www.crummy.com/software/BeautifulSoup/bs4/doc/#css-selectors
///       https://facelessuser.github.io/soupsieve/selectors/
/// Args:
///   - selector: CSS selector. Required
///   - namespaces:
///   - limit: select() returns all the tags and strings that match your CSS selector. 
///            This can take a while if the document is large. If you don’t need all the results, you can pass in a number for limit.
///            This works just like the LIMIT keyword in SQL. It tells Beautiful Soup to stop gathering results after it’s found a certain number.
Method select(selector As %String, namespaces = {##class(%SYS.Python).None()}, limit As %Integer = {##class(%SYS.Python).None()}) [ CodeMode = expression ]
{
..selectint(selector, namespaces, limit)
}

Method selectint(selector As %String, namespaces, limit) [ Language = python ]
{
	import iris
	tags = iris.cls("%ListOfObjects")._New()
	for tag in self.py.select(selector, namespaces, limit):
	    tags.Insert(iris.cls("dc.ed.html.Tag")._New(tag))
	return tags
}

Property tag As %SYS.Python;

Method %OnNew(py As %SYS.Python) As %Status
{
	set ..py = py
	quit $$$OK
}

}
