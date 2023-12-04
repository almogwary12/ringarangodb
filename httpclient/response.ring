class Response {
    
    func header key 
        return hdr[key]
    func setHeader key, value 
        self.hdr[key] = value
    func setBody cRes
        if hdr["Content-Type"] = CON_TYPE_JSON
            self.body = json2list(cRes)
        else 
            self.body = cRes
        ok
    func getBody 
        return self.body
    func getStatusCode 
        return statusCode
    func success {
        return  (statusCode = 200 or statusCode = 201 or statusCode = 202)
    }

    func ParseBody field , object{
        if  not inList(field, body){
            return unMarshal(body, object)
        else
            return unMarshal(body[field], object)
        }
        return null
    }

    func parseBodyArray field, cObject{
        objs = []
        if  inList(field, body){
            colls =  body[:result]
            if isList(colls){
                for i = 1  to len(colls){
                    objs + unMarshal(colls[i], cObject)
                }
            }
        else 
            for i in body{
                objs + unMarshal(i, cObject)
            }
        }

        return objs
    }
    private 
        statusCode
        request
        endPoint
        hdr = []
        body
}
