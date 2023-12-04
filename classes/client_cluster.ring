keyFollowLeaderRedirect  = "arangodb-followLeaderRedirect"


class cluster{
    connectionBuilder 
	servers            = []
	endpoints          = []
	current           
	defaultTimeout     = 900
	Authentication
    func init config, connectionBuilder, endPoints{
        if isNull(connectionBuilder ){
            raise("Must provide a connection builder")
        }
        if len(endpoints) = 0 {
            raise("Must provide at least 1 endpoint")
        }
        if config[:DefaultTimeout] = 0 {
            config[:DefaultTimeout] = defaultTimeout
        }
   
        connectionBuilder = connectionBuilder
        defaultTimeout =    config[:DefaultTimeout]
        
        // Initialize endpoints
        cConn.UpdateEndpoints(endpoints)
         
        return self
    }

    func NewRequest(method, path string){
        if len(servers) > 0 {
            return servers[1].NewRequest(method, path)
        }
        raise("no servers available")
    }
    func getSpecificServer endpoint  {
        server = null
        for s in servers {
            for x in s.Endpoints() {
                if x = endpoint {
                    server = s 
                    exit
                }
            }
        }
        return server
    }

    func getCurrentServer{
        return servers[current]
    }

    func getNextServer {
        current = (current + 1) % len(servers)
        return servers[current]
    }

    func DoReq ctx, req{
        followLeaderRedirect = true
        if isnull(ctx) {
            ctx = new BackgroundContext
        else 
            v = ctx.getValue(keyFollowLeaderRedirect)
            if not isNull(v){
                followLeaderRedirect = v
            }
        }
        
        server  = null
        serverCount = 0
        durationPerRequest = 0

        endPoint = ctx.getValue(keyEndpoint)
        if not isNull(endpoint){
            s = getSpecificServer(endpoint)
            if not isNull(server) {
                server = s
                durationPerRequest = defaultTimeout
                serverCount = 1
            }
        }
        

        if server = null {
            server = c.getCurrentServer()
            serverCount = len(self.servers)
            durationPerRequest = defaultTimeout / serverCount
        }

        attempt = 1
        while 1 {
            resp = server.DoReq(ctx, req)
        
            if  !followLeaderRedirect {
                return resp
                if req.Written() {
                    // Request has been written to network, do not failover
                }
            }

            attempt++
            if attempt > serverCount {
                return null
            }
            server = getNextServer()
        }
    }
}