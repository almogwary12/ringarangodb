
class DocumentMeta{
    _Key   
	_ID     
	_Rev    
	OldRev 
}
DocumentMetaSlice = []

func validateKey key   {
	if key = "" {
		raise("key is empty")
	}
	return null
}

func keys{
    keys = []
    for i in DocumentMetaSlice
        keys + i.Key
    next
    return keys
}

func Revs  {
	revs = []
	for i in  DocumentMetaSlice{
		revs + i.Rev
	}
	return revs
}

func  IDs {
	ids = []
	for i in  DocumentMetaSlice {
		ids + m.ID
	}
	return ids
}
