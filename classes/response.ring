
class ArangoResponse {
    error
    code
    response
    body
    func init resp{
        self.response = resp
        self.body = response.getBody()
        self.code = response.getStatusCode()
    }
    func success {
        return  (code = 200 or code = 201 or code = 202) 
    }

    func ParseBody field, object{
        return response.parseBody(field, object)
    }

    func parseBodyArray field, object{
        return response.parseBodyArray(field, object)
    }


    func getBody{
        return self.body
    }
}



class ArangoResponseOk from ArangoResponse{
    func init resp{
        super.init(resp)
        error = false
    }
  
}

class ArangoResponseError from ArangoResponse{
    errorMessage
    errorNum
    func init resp{
        super.init(resp)
        error = true
        if body != "" and not  isNull(body){
            errorMessage = body[:errorMessage]
            errorNum = body[:errorNum]
        }
    }
    
}
