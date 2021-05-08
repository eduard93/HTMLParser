Class dc.ed.html.Parser
{

/// Install required python modules
/// set sc = ##class(dc.ed.html.Parser).install()
ClassMethod install() As %Status
{
	#dim sc As %Status = $$$OK
	for module = "beautifulsoup4", "lxml", "requests" {
		set sc = ##class(%SYS.Python).Install(module)
		quit:$$$ISERR(sc)
	}
	quit sc
}

/// set doc = ##class(dc.ed.html.Parser).parse("https://google.com")
ClassMethod parse(html As %String) As Doc [ Language = python ]
{
	import iris
	import bs4
	import requests
	from urllib.parse import urlparse
	
	try:
		result = urlparse(html)
		is_url = all([result.scheme, result.netloc])
	except ValueError:
		is_url = False

	if is_url:
		html = requests.get(html).text
	
	doc = bs4.BeautifulSoup(html, "lxml")
	
	return iris.cls("dc.ed.html.Doc")._New(doc)
}

/// do ##class(dc.ed.html.Parser).Test()
ClassMethod Test()
{
	set html = ##class(%Dictionary.XDataDefinition).IDKEYOpen($classname(), "Sample").Data.Read($$$MaxStringLength)
	#dim doc As Doc
	set doc = ..parse(html)
	
	
	// filter search
	#dim tags As List Of dc.ed.html.Tag
	set tags = doc.findall("div")
	kill tags
	
	
	// CSS selector search
	set tags = doc.select(".a")
	
	for i=1:1:tags.Count() {
		set tag = tags.GetAt(i)
		do tag.display()		
	}
}

XData Sample [ MimeType = html ]
{
<html><div class="a" /><div class="a">abc</div><div class="b"/></html>
}

}
