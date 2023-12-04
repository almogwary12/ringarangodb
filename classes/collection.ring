ReplicationFactorSatellite = -1
CollectionStatusNewBorn    =  1
CollectionStatusUnloaded   =  2
CollectionStatusLoaded     =  3
CollectionStatusUnloading  =  4
CollectionStatusDeleted    =  5
CollectionStatusLoading    =  6
CollectionStatusError      =  0

CollectionTypeDocument = 2
CollectionTypeEdge     = 3

ComputeOnInsert   = "insert"
ComputeOnUpdate   = "update"
ComputeOnReplace  = "replace"

KeyGeneratorTraditional   = "traditional"
KeyGeneratorAutoIncrement = "autoincrement"

ShardingStrategyCommunityCompat            = "community-compat"
ShardingStrategyEnterpriseCompat           = "enterprise-compat"
ShardingStrategyEnterpriseSmartEdgeCompat  = "enterprise-smart-edge-compat"
ShardingStrategyHash                       = "hash"
ShardingStrategyEnterpriseHashSmartEdge    = "enterprise-hash-smart-edge"

CollectionSchemaLevelNone      = "none"
CollectionSchemaLevelNew       = "new"
CollectionSchemaLevelModerate  = "moderate"
CollectionSchemaLevelStrict    = "strict"
class ComputedValue  {
	Name 
	Expression 
	ComputeOn 
	Overwrite 
	FailOnWarning 
	KeepNull 
}


class CollectionKeyOptions  {

	AllowUserKeys
	AllowUserKeysPtr 
	Type 
	Increment 
	Offset 

    func Init{
        if isNull(AllowUserKeysPtr){
            if AllowUserKeys {
                cAllowUserKeysPtr = ref(AllowUserKeys)
            }
	    }
    }
}

class CreateCollectionOptions  {
	CacheEnabled 
	ComputedValues 
	DistributeShardsLike 
	DoCompact 
	IndexBuckets
	InternalValidatorType 
	IsDisjoint 
	IsSmart 
	IsSystem 
	IsVolatile 
	JournalSize 
	KeyOptions 
	MinReplicationFactor 
	NumberOfShards 
	ReplicationFactor 
	Schema .
	ShardingStrategy
	ShardKeys
	SmartGraphAttribute 
	SmartJoinAttribute 
	SyncByRevisio
	Type 
	WaitForSync
	WriteConcern 

    func Init {
        KeyOptions.Init()
    }
}
class Schema {
    Rule 
	Level   
	Message 
	Type     
}
class createCollectionOptionsInternal{
	CacheEnabled          
	ComputedValues        
	DistributeShardsLike  
	DoCompact             
	IndexBuckets          
	InternalValidatorType
	IsDisjoint            
	IsSmart               
	IsSystem             
	IsVolatile            
	JournalSize           
	KeyOptions            
	MinReplicationFactor 
	Name                
	NumberOfShards       
	ReplicationFactor    
	Schema               
	ShardingStrategy     
	ShardKeys            
	SmartGraphAttribute  
	SmartJoinAttribute   
	SyncByRevision       
	Type                
	WaitForSync         
	WriteConcern      

    func fromExternal i{
        CacheEnabled = i.CacheEnabled
        ComputedValues = i.ComputedValues
        DistributeShardsLike = i.DistributeShardsLike
        DoCompact = i.DoCompact
        IndexBuckets = i.IndexBuckets
        InternalValidatorType = i.InternalValidatorType
        IsDisjoint = i.IsDisjoint
        IsSmart = i.IsSmart
        IsSystem = i.IsSystem
        IsVolatile = i.IsVolatile
        JournalSize = i.JournalSize
        KeyOptions = i.KeyOptions
        MinReplicationFactor = i.MinReplicationFactor
        NumberOfShards = i.NumberOfShards
        ReplicationFactor = replicationFactor(i.ReplicationFactor)
        Schema = i.Schema
        ShardingStrategy = i.ShardingStrategy
        ShardKeys = i.ShardKeys
        SmartGraphAttribute = i.SmartGraphAttribute
        SmartJoinAttribute = i.SmartJoinAttribute
        SyncByRevision = i.SyncByRevision
        Type = i.Type
        WaitForSync = i.WaitForSync
        WriteConcern = i.WriteConcern

    }  
}

class CollectionInfo{
    ID 
	Name 
	Status 
	Status
	Type 
	IsSystem 
	GloballyUniqueId
	Checksum 
}
class Collection  {
    name
    database
    conn
    info
    func init name, db{
        self.name = name
        if name = ""{
            raise("collection name is requiered")
        }
        if isNull(db){
            raise("Database Is Null")
        }
        self.database = db
        self.conn = db.conn
        return self
    }

    func  relPath apiName  {
        return db.relPath() + "/_api" + "/"+ apiName + "/" + name
    }
	func Name{
        return name
    }

	func DocumentExists ctx , key {
		req = conn.NewRequest("HEAD", PathJoin([relPath("document") , key]))
		conn.log()
		applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		
		if resp.success(){ 
			return true
		else 
			if not isNull(resp.errorMessage){
				see resp.errorMessage
			}
			return false
		}
		
	}


	func ReadDocument ctx, key{
		req = conn.NewRequest("GET", PathJoin([relPath("document") , key]))
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		if resp.success(){
			meta  = new DocumentMeta
			loadContextResponseValues(cs, resp)
			return resp.ParseBody(null, meta)
		else 
			resp.errorMessage
			return null
		}
		
	}

	func  ReadDocuments ctx , keys  {
        if isNull(keys) or keys = [] {
            see "Keys is Null"
            return 
        }
        req = conn.NewRequest("GET", relPath("document"))
        req.SetQuery("onlyget", "1")
        cs = applyContextSettings(ctx, req)
        req.setBody(jsonList(keys))
		
		
        resp = conn.HandelRequest(ctx, req)

        if resp.success(){
            loadContextResponseValues(cs, resp)
            res = resp.getResult()
            return res
        else 
            see resp.errorMessage
            return null
        }
    }

	func  CreateDocument ctx , document {
		if isNull(document ){
			see "Docuemnt Is Null"
			return
		}
		req = conn.NewRequest("POST", relPath("document"))
		
		req.SetBody(list2json(document))
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		if resp.success(){
			if cs.Silent = true{
				return new DocumentMeta
			else 
				return resp.ParseBody(null, new DocumentMeta)
			}
		else
			see resp.errorMessage
			return null
		}
		
	}

	func CreateDocuments ctx , documents {
		req = conn.NewRequest("POST", relPath("document"))
		docs = jsonlist(documents)
		req.SetBody(docs)
		
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		
		if resp.success(){
			res = resp.getBody()
			if cs.Silent = true {
				return null
			}
			return res
		else 
			see resp.errorMessage
			return null
		}
	}

	func UpdateDocument ctx, key, update{
		if isNull(update) or not isList(update) {
			see "Bad Parameter"
			return
		}
		req = conn.NewRequest("PATCH", pathJoin([relPath("document"), key]))
		
		 req.SetBody(list2json(update))
			
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		if resp.success(){
			if cs.Silent = true {
				return null
			}
			meta = new DocumentMeta
			
			if not isNull(cs.ReturnOld) {
				return  resp.ParseBody("old", data)
			}
			if not isNull(cs.ReturnNew) {
				return resp.ParseBody("new", meta)
			}

			return  resp.ParseBody(null, meta)
		else 
			see resp.errorMessage
			return null
		}

	}

	func Status ctx {
        req = conn.NewRequest("GET", relPath("collection"))
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){ 
			res = resp.getBody()
            info = new CollectionInfo{
				GloballyUniqueId = res[:GloballyUniqueId]
				IsSystem = res[:IsSystem]
				type = res[:type]
				name = res[:name]
				id = res[:id]
				Status = res[:Status]
			}
            
            return info
        else
            see resp.errorMessage
            return CollectionStatusError
        }
       
    }

	func  UpdateDocuments ctx, keys, updates {
		req = conn.NewRequest("PATCH", relPath("document"))
		cs = applyContextSettings(ctx, req)

		merageList = merageList(keys, cs.Revisions)
		cBody = jsonList(merageObject(merageList, updates))
		req.SetBody(cBody)
		resp = conn.HandelRequest(ctx, req)
	
		if resp.success(){
			if cs.Silent = true{
				return null
			}
			res = resp.parseBodyArray(null, "DocumentMeta")
			return res
		else 
			see resp.errorMessage
			return null
		}	
		
	}

	func ReplaceDocument ctx , key, document {
		if isNull(document) {
			see "Error :Docuemnt is Null"
			return 
		}
		req = conn.NewRequest("PUT", pathJoin([relPath("document"), key]))
		req.SetBody(document)
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		
		if resp.success(){
			if cs.Silent = true {
				return  null
			}
			meta = new DocumentMeta
			if not isNull(cs.ReturnOld) {
				return  resp.ParseBody("old", meta)
			}
			if not isNull(cs.ReturnNew) {
				return resp.ParseBody("new", meta)
			}
			return  resp.ParseBody(null, meta)

		else 
			see errorMessage 
			return null
			
		}
		
	}


	func ReplaceDocuments ctx , keys , documents {
	
		req = conn.NewRequest("PUT", relPath("document"))
		cs  = applyContextSettings(ctx, req)
		merageList = merageList(keys, cs.Revisions)
		cBody = jsonList(merageObject(merageList, documents))
		req.SetBody(cBody)
		resp = conn.HandelRequest(ctx, req)
		if resp.success() {
			if cs.Silent {
				return null
			}
			return resp.getBody()
		else 
			see resp.errorMessage 
			return null
		}
		
	}

	func RemoveDocument ctx , key  {
		req = conn.NewRequest("DELETE", pathJoin([relPath("document"), key]))
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		if resp.success() {
			if cs.Silent = true{
				return null
			}
			res = resp.getBody()
			meta = new DocumentMeta
			if not isNull(cs.ReturnOld){
				return resp.ParseBody("old", meta)
			}
			return resp.ParseBody(null, meta)
		else 
			see resp.errorMessage 
			return null
		}
		
	}

	func  RemoveDocuments ctx , keys {
		req = conn.NewRequest("DELETE", relPath("document"))
		cs = applyContextSettings(ctx, req)
		body = []
		req.SetBody(metaArray)
		resp = conn.HandelRequest(ctx, req)
		if resp.success() {
			if cs.Silent = true {
				return null
			}
			return resp.getBody()
		else 
			see resp.errorMessage 
			return null
		}
	}

	func merageList keys, revs {
		mergeList = []
		if isNull(keys) and isNull(revs){
			return 
		}

		if isNull(revs) or len(revs) = 0{
			for i = 1 to len(keys){
				mergeList  +  [:_key = keys[i]]
			}
			return mergeList
		}

		if isNull(keys){
			for i = 1 to len(keys){
				mergeList[i] = [:_rev = revs[i]]
			}
			return mergeList
		}

		if len(keys) != len(revs) {
			see "keys must be equal to revs"
			return
		}
		mergeList = []
		for i = 1 to len(keys){
			l = [
				:_key = keys[i],
				:_rev = revs[i]
			]
			mergeList + l
		}
		
		return mergeList
	}

	func merageObject m1, m2 {
		finalupdates = []
		for i = 1 to len(m1){
			key =  m1[i][1][1]
			v   = m1[i][1][2]
			m2[i][key] = v
			finalupdates + m2[i]
		}
		return finalupdates
	}

	func  ImportDocuments ctx , documents , options  {
		
		req = conn.NewRequest("POST", pathJoin([db.relPath(), "_api/import"]))
		
		req.SetQuery("collection", name)
		req.SetQuery("type", "documents")
		if not isNull(options) {
			if options.FromPrefix != "" and not isNull(options.FromPrefix) {
				v = options.FromPrefix
				req.SetQuery("fromPrefix", v)
			}

			if options.ToPrefix != "" and not isNull(options.ToPrefix) {
				v = options.ToPrefix
				req.SetQuery("toPrefix", v)
			}

			if options.Overwrite != "" and not isNull(options.Overwrite) {
				v = options.Overwrite
				req.SetQuery("overwrite", v)
			}

			if options.OnDuplicate != "" and not isNull(options.OnDuplicate) {
				v = options.OnDuplicate
				req.SetQuery("onDuplicate", v)
			}

			if options.Complete != "" and not isNull(options.Complete) {
				v = options.Complete
				req.SetQuery("complete", v)
			}

		}
	    req.SetBody(documents)
		cs = applyContextSettings(ctx, req)
		resp = conn.HandelRequest(ctx, req)
		
		if  resp.success(){
			res = resp.getBody()
			return res
		else 
			see resp.errorMessage
			return null
		}
		// Parse response
		//|# var data ImportDocumentStatistics
		//|# if err := resp.ParseBody("", &data); err != nil {
		//|# 	return ImportDocumentStatistics{}, WithStack(err)
		//|# }
		// Import details (if needed)
		//|# if details := cs.ImportDetails; details != nil {
		//|# 	if err := resp.ParseBody("details", details); err != nil {
		//|# 		return ImportDocumentStatistics{}, WithStack(err)
		//|# 	}
		//|# }
	}

	func Database {
        return self.database
    }

	func Count{

    }

	func Statistics ctx{
        
    }

	func Revision ctx {

    }

	func Checksum ctx , withRevisions , withData {

    }

	func Properties ctx {
        
    }

	func SetProperties ctx , options {

    }

	func Shards ctx , details {

    }

	func Lload ctx {

    }

	func Unload ctx {

    }

	func Remove ctx {

    }

	func Truncate ctx {
        
    }

	func Rename ctx {

    }

	Indexes

	Documents
}

class KeyOptions  {
    Type 
    AllowUserKeys 
    LastValue     
}

class CollectionProperties  {
	CollectionInfo
	error
	WaitForSync 
	DoCompact 
	JournalSize 
	CacheEnabled 
	ComputedValues  = []
	KeyOptions 
	NumberOfShards 
	ShardKeys 
	ReplicationFactor 
	MinReplicationFactor 
	WriteConcern
	SmartJoinAttribute 
	ShardingStrategy 
	DistributeShardsLike 
	UsesRevisionsAsDocumentIds 
	SyncByRevision 
	Revision 
	Schema 
	IsDisjoint 
	IsSmartChild
	InternalValidatorType 
	IsSmart
	StatusString 
	TempObjectId 
	ObjectId

    func  IsSatellite {
        return ReplicationFactor = ReplicationFactorSatellite
    }
}

class CollectionShards  {
	CollectionProperties
	Shards 
}

class CollectionStatistics  {
	erro
	CollectionProperties
	Count 
	JournalSize 
	Figures  
}

class Figures {
    DataFiles
    UncollectedLogfileEntries 
    DocumentReferences 
    CompactionStatus   
    Compactors 
    Dead 
    Indexes 
    ReadCache
    WaitingFor
    Alive  
    LastTick 
    Journals 
    Revisions
    DocumentsSize 
    CacheInUse
    CacheSize 
    CacheUsage 
}

class DataFiles  {
    Count 
    FileSize 
} 
class CompactionStatus {
    Message 
    Time 
} 
class Compactors {
    Count
    FileSize
}
class Dead {
    Count 
    Deletion 
    Size 
} 
class Indexes {
    Count
    Size
} 
class ReadCache {
    Count
    Size
}
class Alive{
    count 
    Size
}
class Journals{
    Count
    FileSize
}
class Revisions{
    Count 
    Size
}
