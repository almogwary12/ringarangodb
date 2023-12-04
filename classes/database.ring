
func newDatabase name, con{
    if name = ""{
        return new Error("Name Is Empty")
    }
    if isNull(con){
        return new Error("Connection Not Set!")
    }
   return new Database(name, con)
}
class  DatabaseInfo  {
	ID  
	Name 
	Path 
	IsSystem  
	ReplicationFactor 
	WriteConcern 
	Sharding
	ReplicationVersion 
}

class Database {
    name 
    conn
    func init dbName , conn{
        self.name = dbName
        self.conn = conn
    }

    func relPath{
        return "/_db/"+ name
    }

    func name {
        return name
    }

    func EngineInfo ctx {
        req = conn.NewRequest("GET",relPath()+ "/_api/engine")
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            ? resp.result
        else
            ? resp.errorMessage
        }
    }

    func  Info ctx {
        req = conn.NewRequest("GET", relPath() +"/_api/database/current")
        applyContextSettings(ctx, req)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            info = new DatabaseInfo
            return resp.parsBody("result", info)
        else
            see resp.errorMessage
            return null
        }
        
    }

    func Remove ctx {
        req = conn.NewRequest("DELETE", "/_db/_system/_api/database/"+ name)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            return true
        else
            ? resp.errorMessage
            return false
        }
    }

    func  Query ctx , query, bindVars {
        req = conn.NewRequest("POST", relPath()+ "/_api/cursor")
        
        input = new queryRequest
        input.Query =    query
        input.BindVars = bindVars
        
        input.applyContextSettings(ctx)
        req.SetBody(marshal(input))
        cs = applyContextSettings(ctx, req)

        //connection.log(true)

        resp = conn.HandelRequest(ctx, req)
        
        if resp.success(){
            res = resp.getBody()
            data = resp.parsBody(null, new CursorData)
            data{
                extra = new CursorExtra{
                    stats = unmarshal(res[:extra][:stats], new CursorStats)
                    warnings = res[:extra][:warnings]
                }
            } 
            return new Cursor(data, req.endpoint, self, cs.AllowDirtyReads)
        else
            ? resp.errorMessage
            return null
        }
    
    }

    func Collection ctx , name {
        req = conn.NewRequest("GET", relPath() + "/_api/collection/"+ name)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            return new Collection(name, self)
        else
            see resp.errorMessage
            return null
        }
    }

    func CollectionExists ctx , name {
        req = conn.NewRequest("GET", relPath() + "/_api/collection/" + name)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            return true
        else 
            return false
        }
    }

    func  Collections ctx {
        req  =conn.NewRequest("GET", relPath() + "/_api/collection")
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            res = resp.getBody()
            return res["result"]
        else 
            return []
        }
    }


    func CreateCollection ctx , name, options {
        
        input = new createCollectionOptionsInternal
        if not isNull(options) {
            options.Init()
            input.fromExternal(options)
        }
        input.name = name
        req = conn.NewRequest("POST", relPath() + "/_api/collection")
        req.SetBody(marshal(input))
        
        applyContextSettings(ctx, req)
        resp = conn.HandelRequest(ctx, req)
        
        if resp.success(){
            return new Collection(name, self)
        else
            see resp.errorMessage
            return null
        }

    }

    func validateQuery ctx , query  {
        req = conn.NewRequest("POST", PathJoin([relPath(), "_api/query"]))
        input = new parseQueryRequest
        input.Query = query
        req.setBody(marshal(input))
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            res = resp.getResult()
            return res
        else 
            see resp.errorMessage
            return null
        }
    }

    func ExplainQuery ctx, query, bindVars, opts {
        req = conn.NewRequest("POST", PathJoin([relPath() , "_api/explain"]))
        input = new ExplainQueryRequest
        if not isNull(opts){
            input.options = opts
        }
        
        if not isNull(bindVars){
            input.bindVars = bindVars
        }
        conn.log(true)
        input.query = query
        body = marshal(input)
        req.SetBody(body)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            return resp.getresult()
        else 
            see resp.errorMessage
            return null
        }
    }

    func OptimizerRulesForQueries ctx  {
        req = conn.NewRequest("GET", pathJoin([relPath(), "_api/query/rules"]))
        resp = conn.HandelRequest(ctx, req)
        if resp.success() {
            res = resp.getResult()
            return res
        else
            see res.errorMessage
            return null
        }    
    }
    //test from here
    func Transaction ctx , action , options {
        req = conn.NewRequest("POST", pathJoin([d.relPath(), "_api/transaction"]))
        input = new TransactionRequest
        input.Action = action
        
        if not isNull(options){
            input.MaxTransactionSize = options.MaxTransactionSize
            input.LockTimeout = options.LockTimeout
            input.WaitForSync = options.WaitForSync
            input.IntermediateCommitCount = options.IntermediateCommitCount
            input.Params = options.Params
            input.IntermediateCommitSize = options.IntermediateCommitSize
            input.Collections.Read = options.ReadCollections
            input.Collections.Write = options.WriteCollections
            input.Collections.Exclusive = options.ExclusiveCollections
        }
        req.SetBody(marshal(input))
        resp = conn.HandelRequest(ctx, req)
        if resp.success() {
            res = resp.getResult()
            return res
        else
            see errorMessage
            return null
        }
        
    }

    func BeginTransaction ctx , cols , opts {
        req = conn.NewRequest("POST", pathJoin([relPath(), "_api/transaction/begin"]))
        reqBody = new beginTransactionRequest
        if not isNull(opts) {
            reqBody.WaitForSync = opts.WaitForSync
            reqBody.AllowImplicit = opts.AllowImplicit
            reqBody.LockTimeout = opts.LockTimeout
        }
        reqBody.Collections = cols
        req.SetBody(marshal(reqBody))
           
        resp = conn.HandelRequest(ctx, req)
       
        if resp.success(){
            res = resp.getResult()
        else
            see resp.errorMessage
            return null
        }

    }

    func requestForTransaction ctx , tid , method {
        req  = conn.NewRequest(method, pathJoin([d.relPath(), "_api/transaction/", string(tid)]))
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            res = res.getBody()
            return res
        else 
            see resp.errorMessage
            return null
        }
        
    }

    func CommitTransaction ctx , tid , opts  {
        requestForTransaction(ctx, tid, "PUT")
    }

    func AbortTransaction ctx, tid , opts  {
        requestForTransaction(ctx, tid, "DELETE")
    }

    func TransactionStatus ctx , tid {
        return requestForTransaction(ctx, tid, "GET")
    }

}
