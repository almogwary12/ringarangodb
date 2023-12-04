DatabaseShardingSingle  = "single"
DatabaseShardingNone    = ""
DatabaseReplicationVersionOne  = "1"
DatabaseReplicationVersionTwo  = "2"

class ClientDatabaseConfig {
    Connection 
    authentication
    versionInfo = [
        :server = "",
        :version = "",
        :license = "",
        :Details = []
    ]
    func IsEnterprise
	    return versionInfo[:license] = "enterprise"
    

}
class ClientDatabase{
    
    Connection

	ClientDatabases

	ClientUsers

	ClientCluster

	ClientServerInfo

	ClientServerAdmin

	ClientReplication

	ClientAdminBackup

	ClientFoxx

	ClientAsyncJob

	ClientLog

    config 

    func init config{
        self.config = config
        if isNull(config)
            raise("Error : Connection not set")
        ok
        self.Connection = config.Connection
        if config.authentication != null 
            Connection.setAuthentication(config.authentication)
        ok
    }
    func clusterEndPoints ctx, dbName{
        str = ""
        if dbName = ""
            url = "_api/cluster/endpoints"
        else 
            url = "_db"+dbname+ "_api/cluster/endpoints"
        ok
        req = connection.Request("GET", url)
        applyContextSettings(ctx, req)
        resp = connection.HandelRequest(req)

        if resp[:error] != "false"{
            ? resp[:error]
        else
            return resp
        }

    }

    func Database ctx, dbName {
        req  = connection.newRequest("GET", "/_db/"+ dbName+ "/_api/database/current")
        resp = connection.HandelRequest(ctx, req)
       
        if resp.success(){
            return new Database(dbName, this.connection)
        else
            see resp.errorMessage
            return null
        }
        

        return result
    }

    func DatabaseExists ctx, dbname{
        req = connection.NewRequest("GET", "/_db/"+ dbname +"/_api/database/current")
        resp = connection.HandelRequest(ctx, req)
        if resp.success(){
            return true
        else 
            return false
        }
        
    }

    func Databases ctx{
        return listDatabases(ctx, connection, "/_db/_system/_api/database")
    }

    func AccessibleDatabases ctx{
        return listDatabases(ctx, connection, "/_db/_system/_api/database/user")
    }

    func listDatabases ctx  , conn, path  {
        req = conn.NewRequest("GET", path)
        resp = conn.HandelRequest(ctx, req)
        if resp.success(){
            body = resp.getBody()
            return body[:result]
        else 
            see resp.errorMessage
            return 
        }
    }

    func clusterEndPoints2 ctx, dbName{
        resp = c.clusterEndpoints(ctx, dbname)
        
        endpoints = []
        for i in  resp[:endpoints]{
            endpoints + i[:endpoint]
        }

        // Update connection
        //|# if err  = c.conn.UpdateEndpoints(endpoints); err != nil {
        //|#     return WithStack(err)
        //|# }

        return null

    }
    func CreateDatabase ctx, dbname , options{
        req  = connection.NewRequest("POST", "/_db/_system/_api/database")
        if not isNull(options){
            options.name = dbname
            req.setBody(marshal(options))
        else
            req.setBody([
                :name = dbName
            ])
        }
        
        resp = connection.HandelRequest(ctx, req)
        if resp.success(){
            return newDatabase(dbname, connection)
        else 
            see resp.errorMessage
            return 
        }
        
        return 
    }


    func connetion {
        return self.connection
    }
        
    func SynchronizeEndpoints2 ctx, dbName{

    }
}
class CreateDatabaseOption{
    name
    users 
    options
}
class CreateDatabaseDefaultOptions{
    ReplicationFactor 
	WriteConcern 
	Sharding 
	ReplicationVersion 
}