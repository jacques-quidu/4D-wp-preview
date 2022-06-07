//%attributes = {}
ds:C1482.Document.all().drop()  //delete all documents
ASSERT:C1129(ds:C1482.Document.all().length=0)

//add some documents...

var $entity : cs:C1710.DocumentEntity

$entity:=ds:C1482.Document.new()

$doc:=WP New:C1317
WP SET TEXT:C1574($doc; "simple text"; wk replace:K81:177)
WP INSERT BREAK:C1413($doc; wk page break:K81:188; wk append:K81:179)
WP SET TEXT:C1574($doc; "more text..."; wk append:K81:179)
WP INSERT BREAK:C1413($doc; wk page break:K81:188; wk append:K81:179)
WP SET TEXT:C1574($doc; "and more text..."; wk append:K81:179)

$title:="simple text"

$doc.title:=$title

$entity.title:=$title
$entity.wpdoc:=$doc

$entity.preview:=ds:C1482.Document.getPagePreview($doc; 1; True:C214)
//WRITE PICTURE FILE("page.svg"; $entity.preview)
$entity.previewPageIndex:=1
$entity.lastPreviewPageIndex:=1
$entity.numPages:=3
$entity.background:=True:C214

$entity.save()

var $docPaths : Collection
$docPaths:=New collection:C1472
$docPaths.push("brochure.4wp")
$docPaths.push("test anchored images.4wp")
$docPaths.push("test section background.4wp")
$docPaths.push("test sections complex.4wp")
$docPaths.push("test tables.4wp")
$docPaths.push("test table header.4wp")
$docPaths.push("test columns and column breaks.4wp")
$docPaths.push("test expressions and urls.4wp")
$docPaths.push("test headers and footers.4wp")
$docPaths.push("test inline images.4wp")
$docPaths.push("test paragraph styles.4wp")


For each ($path; $docPaths)
	$entity:=ds:C1482.Document.new()
	
	$title:=$path
	$pos:=Position:C15(".4wp"; $title)
	If ($pos>=1)
		$title:=Substring:C12($title; 1; $pos-1)
	End if 
	
	$pathFull:=Get 4D folder:C485(Current resources folder:K5:16)+$path
	$doc:=WP Import document:C1318($pathFull)
	$doc.title:=$title
	$entity.title:=$title
	$entity.wpdoc:=$doc
	$entity.numPages:=WP Get page count:C1412($doc)
	$entity.background:=True:C214
	
	$entity.preview:=ds:C1482.Document.getPagePreview($doc; 1; True:C214)
	//WRITE PICTURE FILE("page.svg"; $entity.preview)
	$entity.previewPageIndex:=1
	$entity.lastPreviewPageIndex:=1
	
	$entity.save()
End for each 


