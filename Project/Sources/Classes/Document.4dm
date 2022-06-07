Class extends DataClass

exposed Function getPagePreview($doc : Object; $index : Integer; $background : Boolean)->$result : Picture
	
	$options:=New object:C1471
	$options.pageIndex:=$index
	$options.optimizedFor:="screen"
	$options.visibleBackground:=$background
	
	var $textSVG : Text
	var $preview : Picture
	
	If (True:C214)
		WP EXPORT VARIABLE:C1319($doc; $textSVG; wk svg:K81:356; $options)
		$rootSVG:=DOM Parse XML variable:C720($textSVG)
		SVG EXPORT TO PICTURE:C1017($rootSVG; $preview; Copy XML data source:K45:17)
		DOM CLOSE XML:C722($rootSVG)
	Else 
		//not working -> PDF not supported as image datasource by web studio
		var $blob : Blob
		WP EXPORT VARIABLE:C1319($doc; $blob; wk pdf:K81:315; $options)
		BLOB TO PICTURE:C682($blob; $preview)
	End if 
	
	$result:=$preview
	
	
exposed Function updatePagePreview($doc : cs:C1710.DocumentEntity; $index : Integer; $background : Boolean)->$result : cs:C1710.DocumentEntity
	
	var $preview : Picture
	
	$docWP:=$doc.wpdoc
	If ($index<1)
		$index:=1
	End if 
	If ($index>$doc.numPages)
		$index:=$doc.numPages
	End if 
	If ($index#$doc.previewPageIndex)
		$doc.previewPageIndex:=$index
	End if 
	
	If (($doc.lastPreviewPageIndex#$index) | ($background#$doc.background))
		
		$preview:=ds:C1482.Document.getPagePreview($docWP; $index; $background)
		
		$doc.preview:=$preview
		$doc.previewPageIndex:=$index
		$doc.lastPreviewPageIndex:=$index
		$doc.background:=$background
		
		$doc.save()
	End if 
	
	$result:=$doc
	
exposed Function initDocuments()
	If (ds:C1482.Document.all().length=0)
		initdocs
	End if 
	
exposed Function addDocumentFromFile()->$result : cs:C1710.DocumentSelection
	
	$vhDocRef:=Open document:C264(""; ".4WP")  // Select the document of your choice
	If (OK=1)  // If a document has been chosen
		var $blob : Blob
		
		CLOSE DOCUMENT:C267($vhDocRef)  // We don't need to keep it open
		DOCUMENT TO BLOB:C525(Document; $blob)  // Load the document
		
		$docWP:=WP New:C1317($blob)
		If (OB Is defined:C1231($docWP))
			If (Not:C34(OB Is empty:C1297($docWP)))
				
				$entity:=ds:C1482.Document.new()
				
				$title:=$docWP.title
				$entity.title:=$title
				$entity.wpdoc:=$docWP
				$entity.numPages:=WP Get page count:C1412($docWP)
				$entity.background:=True:C214
				
				$entity.preview:=ds:C1482.Document.getPagePreview($docWP; 1; True:C214)
				//WRITE PICTURE FILE("page.svg"; $entity.preview)
				$entity.previewPageIndex:=1
				$entity.lastPreviewPageIndex:=1
				
				$entity.save()
			End if 
		End if 
		
		$result:=ds:C1482.Document.all()
		
	End if 
	