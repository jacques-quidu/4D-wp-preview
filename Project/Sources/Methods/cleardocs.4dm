//%attributes = {}

$docs:=ds:C1482.Document.all()

ds:C1482.Document.all().drop()  //delete all documents
ASSERT:C1129(ds:C1482.Document.all().length=0)
