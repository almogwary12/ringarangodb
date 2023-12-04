cursorPlanNodes = []
cursorProfile   = []

class retryData  {
	cursorID       string
	currentBatchID string
}


class cursorStats  {
	writesExecuted
	writesIgnored
	scannedFull
	scannedIndex
	cursorsCreated
	cursorsRearmed
	cacheHits
	cacheMisses
	filtered
	httpRequests
	executionTime
	peakMemoryUsage
///
	intermediateCommits 
	Nodes            
	HttpRequests       
	CursorsCreated 
	CursorsRearmed 
	  
    func WritesExecuted {
        return WritesExecutedInt
    }

    func  WritesIgnored {
        return WritesIgnoredInt
    }

    func ScannedFull {
        return ScannedFullInt
    }

    func  ScannedIndex {
        return ScannedIndexInt
    }

    func Filtered {
        return FilteredInt
    }

    func  FullCount  {
        return FullCountInt
    }

    func  ExecutionTime  {
        return ExecutionTimeInt * 1000
    }

}




class cursorPlan  {
	Nodes              
	Rules             
	Collections         
	Variables           
	EstimatedCost       
	EstimatedNrItems    
	IsModificationQuery 
}
class cursorExtra  {
	Stats    
	Profile  
	Plan    
	Warnings

    func GetProfileRaw {
        if  isNull(Profil){
            return null
        }
        d = Marshal(c.Profile)
        return d
    }

    func cursorExtra GetStatistics {
        return c.Stats
    }

    func  GetPlanRaw {
        if isNull(Plan) {
            return null
        }
        d = Marshal(c.Plan)
        return d
    }
}

class cursorPlanCollection  {
	Name 
	Type 
}


class cursorPlanVariable  {
	ID                           
	Name                         
	IsDataFromCollection        
	IsFullDocumentFromCollection
}
class warn  {
	Code    
	Message
}

class cursorData  {
	Key         
	Count          
	ID                 
	Result      
	HasMore              
	Extra         
	Cached               
	NextBatchID      
	ArangoError
}
class Cursor{
    cursorData
	endpoint         
	resultIndex  = 0
	retryData        
	database            
	conn             
	closed           
	closeMutex       
	allowDirtyReads  
	lastReadWasDirty 
    result
    func init  data , endpoint, db, allowDirtyReads{
        if isNull(db) {
            return raise("Database is Null")
        }
        self.cursorData      = data
        self.endpoint        = endpoint
        self.database        = db
        self.conn            = db.conn
        self.allowDirtyReads = allowDirtyReads
        self.result = data.result
        
        if data.NextBatchID != "" or not isNull(data.NextBatchID) {
            retryData = new retryData{
                cursorID       =  data.ID
                currentBatchID =  "1"
            }
        }

        return self
    }
    func hasMore{
        return resultIndex < len(Result) or cursorData.HasMore
    }
    func  Count {
        return cursorData.Count
    }
    func  Close()  {
        if closed != 0 {
            if cursorData.ID != "" {
                ctx  = WithEndpoint(null, endpoint)
				ctx.getValue(KeyEndpoint)
                req  = conn.NewRequest("DELETE", database.relPath() + "/"+cursorData.ID)
                resp = conn.HandelRequest(ctx, req)
                if resp.success(){
                    return true
                else 
                    see resp.errorMessage
                    return false
                }
            }
        }
        
    }
    func Document ctx {
        return readDocument(ctx, "")
    }

    func  RetryReadDocument ctx {
        if resultIndex > 0 {
            resultIndex--
        }
        return readDocument(ctx, retryData.currentBatchID)
    }

    func readDocument ctx ,retryBatchID  {
        ctx = WithEndpoint(ctx, endpoint)
        if resultIndex >= len(Result) and (cursorData.HasMore or retryBatchID != "") {
            wasDirtyRead = false
            fetchCtx = -1
            if allowDirtyReads {
                fetchCtx = WithAllowDirtyReads(ctx, wasDirtyRead)
            }

            p = relPath() + "/" +cursorData.ID

            if NextBatchID != "" {
                p = relPath() + "/" + cursorData.ID + "/" +NextBatchID
            }

            if retryBatchID != "" {
                p = relPath() + "/" +  retryData.cursorID + "/" +retryBatchID
            }

            if NextBatchID != "" && retryBatchID = "" {
                retryData.currentBatchID = NextBatchID
            }

            req = conn.NewRequest("POST", p)
           
            cs = applyContextSettings(fetchCtx, req)
            resp = conn.HandelRequest(fetchCtx, req)
            if resp.success(){
                loadContextResponseValues(cs, resp)
                self.data = unMarshal(res.getBody(), new cursorData)
            else
                ? resp.errorMessage
                return null
            }
            
            resultIndex = 1
            lastReadWasDirty = wasDirtyRead
        }

        if allowDirtyReads {
            setDirtyReadFlagIfRequired(ctx, lastReadWasDirty)
        }

        resultIndex++
        index = resultIndex
        
        if index > len(Result){
            // Out of data
            return null
        }

        resultPtr  = Result[index]
        meta = unMarshal(resultPtr, new DocumentMeta)

        if isNull(resultPtr) {
            ? :Error
            return null
        } 
        
        return meta   
    }

    func Statistics {
        return cursorData.Extra.Stats
    }

    func Extra {
        return cursorData.Extra
    }
}


