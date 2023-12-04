load "response.ring"


func newConnection config {
    return new ClientConnection(config)
}

class ClientConnection from Connection{
    endPoint
    authentication
    authenticated = false
    jwt
    config
    log = false
    logEndpoint
    func init config {
        super.init([
            :baseUrl = config[:endPoint]
        ])
        self.config = config
        self.endPoint = config[:endPoint]
        self.authentication = config[:authentication]
        self.log = config[:log]
        
        if not authenticated{
            request = newRequest(:POST, "/_open/auth")
            request.setBody([
                :username = authentication.username,
                :password = authentication.password
            ])
            ctx = new  BackgroundContext
            resp = HandelRequest(null, request)
            if resp.success(){
                res  = resp.getBody()
                if not isNull(res[:jwt]) and res[:jwt] != ""{
                    jwt = res[:jwt]
                    self.authenticated = true
                }
            else
                see resp.errorMessage
            }
        }
    }

    func log  {
        self.log = true
    }

    func newRequest method, path{
        request = Request(method, path)
        return request
    }
  
    func HandelRequest ctx, req{
        req.setHeader("Content-Type", CON_TYPE_JSON)
        req.setHeader("Authorization", "Bearer "+jwt) 
        if log = true {
            ? req.endPoint
        }
        resp = DoRequest(req)
        if log = true {
            ? req.endPoint
            ? resp
        }
    
        if not resp.success() {
            return new ArangoResponseError(resp)
        else
            return new ArangoResponseOk(resp)
        }
        log = false
    }

    func Endpoints {
        return []
    }

    func UpdateEndpoints endPoints {
        return []
    }

    func Protocols {
        return []
    }

    func setAuthentication auth{
        self.authentication = auth
    }

}




