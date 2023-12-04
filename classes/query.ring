keyQueryCount                       = "arangodb-query-count"
keyQueryBatchSize                   = "arangodb-query-batchSize"
keyQueryCache                       = "arangodb-query-cache"
keyQueryMemoryLimit                 = "arangodb-query-memoryLimit"
keyQueryForceOneShardAttributeValue = "arangodb-query-forceOneShardAttributeValue"
keyQueryTTL                         = "arangodb-query-ttl"
keyQueryOptSatSyncWait              = "arangodb-query-opt-satSyncWait"
keyQueryOptFullCount                = "arangodb-query-opt-fullCount"
keyQueryOptStream                   = "arangodb-query-opt-stream"
keyQueryOptProfile                  = "arangodb-query-opt-profile"
keyQueryOptMaxRuntime               = "arangodb-query-opt-maxRuntime"
keyQueryOptOptimizerRules           = "arangodb-query-opt-optimizerRules"
keyQueryShardIds                    = "arangodb-query-opt-shardIds"
keyFillBlockCache                   = "arangodb-query-opt-fillBlockCache"
keyAllowRetry                       = "arangodb-query-opt-allowRetry"

class QueryRequestOption{
    ShardIds 
    Profile 
    Optimizer
    SatelliteSyncWait 
    FullCount
    MaxPlans 
    Stream 
    MaxRuntime 
    ForceOneShardAttributeValue 
    FillBlockCache 
    AllowRetry 
}
class QueryRequest{
    Count 
	BatchSize 
	Cache 
	MemoryLimit
	TTL 
	Query 
	BindVars
    Options 

    func applyContextSettings ctx {
        if isNull(ctx){
            return
        }
        rawValue = ctx.getValue(keyQueryCount)
        if not isNull(rawValue){
            Count = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryBatchSize)
        if not isNull(rawValue){
            BatchSize = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryShardIds)
        if not isNull(rawValue){
            Options.ShardIds = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryCache)
        if not isNull(rawValue){
            Cache = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryMemoryLimit)
        if not isNull(rawValue){
            MemoryLimit = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryForceOneShardAttributeValue)
        if not isNull(rawValue) {
            Options.ForceOneShardAttributeValue = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryTTL)
        if not isNull(rawValue){
            TTL = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryOptSatSyncWait)
        if not isNull(rawValue) {
            Options.SatelliteSyncWait = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryOptFullCount)
        if not isNull(rawValue) {
            Options.FullCount = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryOptStream)
        if not isNull(rawValue) {
            Options.Stream = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryOptProfile)
        if not isNull(rawValue){
            Options.Profile = rawValue
        }
            
        
        rawValue = ctx.getValue(keyQueryOptMaxRuntime)
        if not isNull(rawValue) {
            Options.MaxRuntime = rawValue
        }
        
        rawValue = ctx.getValue(keyQueryOptOptimizerRules)
        if not isNull(rawValue) && len(rawValue) != 0 {
            Options.Optimizer.Rules = value
        }
        
        rawValue = ctx.getValue(keyFillBlockCache)
        if not isNull(rawValue) {
            Options.FillBlockCache = rawValue
        }
    
        rawValue = ctx.getValue(keyAllowRetry)
        if not isNull(rawValue) {
            Options.AllowRetry = rawValue
        }
        
    }
}
class ExplainQueryOption{
    AllPlans 
	MaxNumberOfPlans 
	Optimizer 
}
class Optimizer{
    rules = []
}
class ExplainQueryRequest{
    Query
    bindVars
    options
}
class parseQueryRequest  {
	Query
}

func WithQueryCount parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryCount, value)
}

func WithQueryBatchSize parent , value {
	return WithValue(contextOrBackground(parent), keyQueryBatchSize, value)
}

func WithQueryShardIds parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryShardIds, value)
}

func WithQueryCache parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryCache, value)
}

func WithQueryMemoryLimit parent, value {
	return WithValue(contextOrBackground(parent), keyQueryMemoryLimit, value)
}

func WithQueryForceOneShardAttributeValue parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryForceOneShardAttributeValue, value)
}

func WithQueryTTL parent , value {
	return WithValue(contextOrBackground(parent), keyQueryTTL, value)
}

func WithQuerySatelliteSyncWait parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryOptSatSyncWait, value)
}

func WithQueryFullCount parent, value  {

	return WithValue(contextOrBackground(parent), keyQueryOptFullCount, value)
}

func WithQueryStream parent , value  {
	
	return WithValue(contextOrBackground(parent), keyQueryOptStream, value)
}

func WithQueryProfile parent , value  {
	v = value

	if v < 0 {
		v = 0
	elseif v > 2 
		v = 2
	}

	return WithValue(contextOrBackground(parent), keyQueryOptProfile, v)
}

func WithQueryMaxRuntime parent, value  {
	return WithValue(contextOrBackground(parent), keyQueryOptMaxRuntime, value)
}

func WithQueryOptimizerRules parent , value  {
	return WithValue(contextOrBackground(parent), keyQueryOptOptimizerRules, value)
}

func WithQueryFillBlockCache parent, value  {
	return WithValue(contextOrBackground(parent), keyFillBlockCache, value)
}

func WithQueryAllowRetry parent, value {
	return WithValue(contextOrBackground(parent), keyAllowRetry, value)
}




