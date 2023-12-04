//content Type

keyRevision                  = "revision"
keyRevisions                 = "revisions"
keyReturnNew                 = "returnNew"
keyReturnOld                 = "returnOld"
keySilent                    = "silent"
keyWaitForSync               = "waitForSync"
keyDetails                   = "details"
keyKeepNull                  = "keepNull"
keyMergeObjects              = "mergeObjects"
keyRawResponse               = "rawResponse"
keyImportDetails             = "importDetails"
keyResponse                  = "response"
keyEndpoint                  = "endpoint"
keyIsRestore                 = "isRestore"
keyIsSystem                  = "isSystem"
keyIgnoreRevs                = "ignoreRevs"
keyEnforceReplicationFactor  = "enforceReplicationFactor"
keyConfigured                = "configured"
keyFollowLeaderRedirect      = "followLeaderRedirect"
keyDBServerID                = "dbserverID"
keyBatchID                   = "batchID"
keyJobIDResponse             = "jobIDResponse"
keyAllowDirtyReads           = "allowDirtyReads"
keyTransactionID             = "transactionID"
keyOverwriteMode             = "overwriteMode"
keyOverwrite                 = "overwrite"
keyUseQueueTimeout           = "use-queue-timeout"
keyMaxQueueTime              = "max-queue-time-seconds"
keyDropCollections           = "drop-collections"
keyDriverFlags               = "driver-flags"
keyRefillIndexCaches         = "driver-refill-index-caches"
keyAsyncRequest              = "async-request"
keyAsyncID                   = "async-id"

OverwriteModeIgnore    = "ignore"
OverwriteModeReplace   = "replace"
OverwriteModeUpdate    = "update"
OverwriteModeConflict  = "conflict"
/////////////////////////////// global func 
func join(arr, sep) {
    result = ""
    for  i = 1 to len(arr) 
        if i != len(arr){
            result += arr[i]
            result += sep
        else
            result += arr[i]
        }
    next
    return result
}
func withValue parent, key, value
	if isNull(parent)
		raise("ERORR : cannot create context from null parent")
	ok
	if isNull(key)
		raise("ERORR : null key")
	ok
	return new Context{
		self.parent = parent
		self.setValue(key, value)
	}

func contextOrBackground ctx 
	if not isNull(ctx)
		return ctx
	ok
	return new BackgroundContext

func WithRevision(parent , revision)  {
	return WithValue(contextOrBackground(parent), keyRevision, revision)
}

func WithRevisions(parent , revisions)  {
	return WithValue(contextOrBackground(parent), keyRevisions, revision)
}

func WithReturnNew(parent, settings)  {
	return WithValue(contextOrBackground(parent), keyReturnNew, settings)
}

func WithReturnOld(parent, settings)  {
	return WithValue(contextOrBackground(parent), keyReturnOld, settings)
}

func WithDetails(parent , values ) {
	v = true
	if len(values) = 1 
		v = value[1]
	ok
	return WithValue(contextOrBackground(parent), keyDetails, v)
}

func WithEndpoint(parent, endpoint){
	return WithValue(contextOrBackground(parent), keyEndpoint, endpoint)
}

func WithKeepNull(parent, value)  {
	return WithValue(contextOrBackground(parent), keyKeepNull, value)
}

func WithMergeObjects(parent , value){
	return WithValue(contextOrBackground(parent), keyMergeObjects, value)
}

func WithSilent(parent , values)  {
	v = true
	if len(values) = 1 {
		v = value[1]
	}
	return WithValue(contextOrBackground(parent), keySilent, v)
}

func WithWaitForSync(parent , values)  {
	v = true
	if len(values) = 1 {
		v = value[1]
	}
	return WithValue(contextOrBackground(parent), keyWaitForSync, v)
}

func WithAllowDirtyReads(parent, wasDirtyRead)  {
	return WithValue(contextOrBackground(parent), keyAllowDirtyReads, wasDirtyRead)
}

func WithArangoQueueTimeout(parent , useQueueTimeout bool) {
	return WithValue(contextOrBackground(parent), keyUseQueueTimeout, useQueueTimeout)
}

func WithArangoQueueTime(parent , duration )  {
	return WithValue(contextOrBackground(parent), keyMaxQueueTime, duration)
}

func WithRawResponse(parent , value){
	return WithValue(contextOrBackground(parent), keyRawResponse, value)
}
func WithResponse(parent , value)  {
	return WithValue(contextOrBackground(parent), keyResponse, value)
}

func WithImportDetails(parent , values) {
	return WithValue(contextOrBackground(parent), keyImportDetails, values)
}

func WithIsRestore(parent , value bool) {
	return WithValue(contextOrBackground(parent), keyIsRestore, value)
}

func WithIsSystem(parent, value bool)  {
	return WithValue(contextOrBackground(parent), keyIsSystem, value)
}

func WithIgnoreRevisions(parent , values) {
	v = true
	if len(values) = 1 {
		v = value[1]
	}
	return WithValue(contextOrBackground(parent), keyIgnoreRevs, v)
}

func WithEnforceReplicationFactor(parent, value bool)  {
	return WithValue(contextOrBackground(parent), keyEnforceReplicationFactor, value)
}

func WithConfigured(parent, values)  {
	v = true
	if len(values) = 1 {
		v = value[1]
	}
	return WithValue(contextOrBackground(parent), keyConfigured, v)
}


func WithFollowLeaderRedirect(parent, value)  {
	return WithValue(contextOrBackground(parent), keyFollowLeaderRedirect, value)
}

func WithDBServerID(parent, id string)  {
	return WithValue(contextOrBackground(parent), keyDBServerID, id)
}

func WithBatchID(parent , id)  {
	return WithValue(contextOrBackground(parent), keyBatchID, id)
}

func WithJobIDResponse(parent , jobID)  {
	return WithValue(contextOrBackground(parent), keyJobIDResponse, jobID)
}

func WithTransactionID(parent , tid TransactionID)  {
	return WithValue(contextOrBackground(parent), keyTransactionID, tid)
}

func WithOverwrite(parent )  {
	return WithValue(contextOrBackground(parent), keyOverwrite, true)
}

func WithDropCollections(parent , values) {
	v = true
	if len(values) = 1 {
		v = value[1]
	}
	return WithValue(contextOrBackground(parent), keyDropCollections, v)
}

func WithDriverFlags(parent , values)  {
	return WithValue(contextOrBackground(parent), keyDriverFlags, values)
}

func WithRefillIndexCaches(parent, value )  {
	return WithValue(contextOrBackground(parent), keyRefillIndexCaches, value)
}

func WithAsync(parent)  {
	return WithValue(contextOrBackground(parent), keyAsyncRequest, true)
}

func WithAsyncID(parent , asyncID )  {
	return WithValue(contextOrBackground(parent), keyAsyncID, asyncID)
}

func loadContextResponseValues(cs, resp) {
	// Parse potential dirty read
	if not isNull( cs.DirtyReadFlag ) 
		dirtyRead = resp.getHeader("X-Arango-Potential-Dirty-Read")
		if dirtyRead != "" 
			cs.DirtyReadFlag = true 
		else 
			cs.DirtyReadFlag = false
		ok
	ok
}
func setDirtyReadFlagIfRequired(ctx , wasDirty) {
	v = ctx.getValue(keyAllowDirtyReads)
	if not isNull(v) 
		ctx.setValue(keyAllowDirtyReads, wasDirty )
	ok
}

func ApplyVersionHeader(ctx , req) {
	val = "go-driver-v1/" + DriverVersion
	if not isNull(ctx) {
		v = ctx.getValue(keyDriverFlags)
		if not isNull(v) {
			val = val + "(" + Join(v, ",") + ")"
		}
	}
	req.setHeader("x-arango-driver", val)
}

////////////////////////////////
func applyContextSettings(ctx , req )  {
	result = new contextSettings
	if isNull(ctx) {
		return result
	}

	// Details
	details = ctx.getValue(keyDetails)
	if not isNull(details){
		req.setQuery("details", details)
		result.details = details
	}
	

	keepNull = ctx.getValue(keyKeepNull)
	if not isNull(keepNull){
		req.setQuery("keepNull", keepNull)
		result.keepNull = keepNull
	}
	
	// MergeObjects
	MergeObjects = ctx.getValue(keyMergeObjects)
	if not isNull(keepNull){
		req.SetQuery("mergeObjects", mergeObjects)
		result.mergeObjects = MergeObjects
	}
	
	// Silent
	silent = ctx.getValue(keySilent)
	if not isNull(silent){
		req.SetQuery("silent", silent)
		result.Silent = silent
	}

	// WaitForSync
	waitForSync = ctx.getValue(keyWaitForSync)
	if not isNull(waitForSync) {
		req.SetQuery("waitForSync", waitForSync)
		result.WaitForSync = waitForSync
	}
	// AllowDirtyReads
	dirtyReadFlag = ctx.getValue(keyAllowDirtyReads)
	req.SetHeader("x-arango-allow-dirty-read", "true")
	result.AllowDirtyReads = true
	if not isNull(dirtyReadFlag)  {
		result.DirtyReadFlag = dirtyReadFlag
	}
	

	// Enable Queue timeout
	useQueueTimeout = ctx.getValue(keyUseQueueTimeout)
	if not isNull(useQueueTimeout) && useQueueTimeout {
		result.QueueTimeout = useQueueTimeout
		timeout = ctx.getValue(keyMaxQueueTime)
		if not isNull(timeout) {
				result.MaxQueueTime = timeout
				req.SetHeader("x-arango-queue-time-seconds", fmt.Sprint(timeout.Seconds()))
		}
		
	}

	// TransactionID
	TransactionID = ctx.getValue(keyTransactionID)
	if not isNull(TransactionID){
		req.SetHeader("x-arango-trx-id", TransactionID)
	}
	// ReturnOld
	v = ctx.getValue(keyReturnOld)
	if not isNull(v){
		req.SetQuery("returnOld", "true")
		result.ReturnOld = v
	}
	// ReturnNew
	v = ctx.getValue(keyReturnNew)
	if not isNull(v)  {
		req.SetQuery("returnNew", "true")
		result.ReturnNew = v
	}
	// If-Match
	rev = ctx.getValue(keyRevision)
	if not isNull(rev){
		req.SetHeader("If-Match", rev)
		result.Revision = rev
	}
	
	// Revisions
	revs = ctx.getValue(keyRevisions)
	if not isNull(revs){
		req.SetQuery("ignoreRevs", "false")
		result.Revisions = revs
	}
	
	// ImportDetails
	idetails = ctx.getValue(keyImportDetails)
	if not isNull(idetails){
		req.SetQuery("details", "true")
		result.ImportDetails = details
	}
	
	// IsRestore
	isRestore = ctx.getValue(keyIsRestore) 
	if not isNull(isRestore){
		req.SetQuery("isRestore", isRestore)
		result.IsRestore = isRestore
	}
	
	// IsSystem
	isSystem = ctx.getValue(keyIsSystem)
	if not isNull(isSystem) {
		req.SetQuery("isSystem", isSystem)
		result.IsSystem = isSystem
	}
	
	// IgnoreRevs
	ignoreRevs = ctx.getValue(keyIgnoreRevs)
	if not isNull(ignoreRevs) {
		req.SetQuery("ignoreRevs",ignoreRevs)
		result.IgnoreRevs = ignoreRevs
	}
	
	// EnforeReplicationFactor
	enforceReplicationFactor = ctx.getValue(keyEnforceReplicationFactor)
	if not isNull(enforceReplicationFactor){
		req.SetQuery("enforceReplicationFactor", enforceReplicationFactor)
		result.EnforceReplicationFactor = enforceReplicationFactor
	}

	// Configured
	configured = ctx.getValue(keyConfigured)
	if not isNull(configured) {
		req.SetQuery("configured", configured)
		result.Configured = &configured
	}
	
	// FollowLeaderRedirect
	followLeaderRedirect = ctx.getValue(keyFollowLeaderRedirect)
	if not isNull(followLeaderRedirect){
		result.FollowLeaderRedirect = followLeaderRedirect
	}

	// DBServerID
	sId= ctx.getValue(keyDBServerID)
	if not isNull(sId){
		req.SetQuery("DBserver", sId)
		result.DBServerID = sId
	}
	
	// BatchID
	bId = ctx.getValue(keyBatchID)
	if not isNull(bId){
		req.SetQuery("batchId", bid)
		result.BatchID = bid
	}
	
	// JobIDResponse
	idRef = ctx.getValue(keyJobIDResponse)
	if not isNull(idRef) {
		result.JobIDResponse = idRef
	}
	
	// OverwriteMode
	mode = ctx.getValue(keyOverwriteMode)
	if not isNull(mode) {
		req.SetQuery("overwriteMode", mode)
		result.OverwriteMode = mode
	}
	
	// DropCollections
	dropCollections = ctx.getValue(keyDropCollections)
	if not isNull(dropCollections){
		req.SetQuery("dropCollections", dropCollections)
		result.DropCollections = dropCollections
	}
	
	// IndexCacheRefilling
	local = ctx.getValue(keyRefillIndexCaches)
	if not isNull(local) {
		req.SetQuery("refillIndexCaches", local)
		result.RefillIndexCaches = local
	}
	
	// Overwrite
	overwrite = ctx.getValue(keyOverwrite)
	if not isNull(overwrite) && overwrite {
		req.SetQuery("overwrite", "true")
		result.Overwrite = true
	}
	

	// AsyncID
	asyncID = ctx.getValue(keyAsyncID);
	if not isNull(asyncID){
		req.SetHeader("x-arango-async-id", asyncID)
	}
	
	return result
}


func withDocumentAt(ctx, index){
	if isNull(ctx) {
		return [null, null]
	}
	// Revisions
	revs = ctx.getValue(keyRevisions)
	if not isNull(revs){
		if index >= len(revs) {
			return [null, "Message: Index out of range: revisions"]
		}
		ctx = WithRevision(ctx, revs[index])
	}
	
	// ReturnOld
	oval = ctx.getValue(keyReturnOld)
	ctx = WithReturnOld(ctx, oval)
	
	// ReturnNew
	nVal = ctx.getValue(keyReturnNew)
	ctx = WithReturnNew(ctx, nVal)
	
	return [ctx, null]
}
     
class ContextSettings
    Silent                   
	WaitForSync              
	ReturnOld                
	ReturnNew                
	Revision                 = Null 
	Revisions                = []
	ImportDetails            = []
	IsRestore                
	IsSystem                 
	AllowDirtyReads          
	DirtyReadFlag            
	IgnoreRevs               
	EnforceReplicationFactor 
	Configured               
	FollowLeaderRedirect     
	DBServerID               
	BatchID                  
	JobIDResponse            
	OverwriteMode            
	Overwrite                
	QueueTimeout             
	MaxQueueTime             
	DropCollections          
	RefillIndexCaches        

class Context{
	parent
	
	func setSetting key, value
		self.settings[key] = value
	func getSettings key
		return settings[key]
	func setValue key, value
		values[key] = value
	func getValue key 
		v = values[key]
		if v = ""{
			return NULL
		else 
			return values[key]
		}
		
	private 
		settings = []
		values = []
}



class BackgroundContext from context 
	func string return "BACKGROUND.context"
class EmptyContext from context 
	func string return "EMPTY.context"
class TodoContext from context 
	func string return "TODO.context"
