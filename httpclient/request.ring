AUTH_TYPE_BASIC  = 1
AUTH_TYPE_BEARER = 2

class Request{
    response 
    func init endPoint, method, headers, params
        self.endPoint = endPoint 
		self.method = method 
		self.hdr = headers 
		self.params = params 
		curl = curl_easy_init()
		curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
	func PerfomeRequest 
        chdr = curl_slist_append(NULL,'Accept-Charset: utf-8')
		if not isNull(self.hdr){
            for h in self.hdr
                chdr = curl_slist_append(chdr, h[1]+ ": "+h[2])
            next
            curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chdr)
        }
		
        pbody = ""
        if not isnull(self.params)
			if not isNull( params.query )
				prepareQuery()	
			ok
			if not isNull(params.body)
				pbody = params.body
			ok
		ok
        switch lower(method) 
		on  "get"
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET")
		on  "post"
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST")
			curl_easy_setopt(curl, CURLOPT_POSTFIELDS, pbody)
		on  "put" 
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT")
			curl_easy_setopt(curl, CURLOPT_POSTFIELDS, pbody)
		on  "patch" 
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH")
			curl_easy_setopt(curl, CURLOPT_POSTFIELDS, pbody)
		on  "delete" 
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE")
			curl_easy_setopt(curl, CURLOPT_POSTFIELDS, pbody)
		on  "head" 
			curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD")
		other 
			raise("Error : Unknown Request Method!")
		off
		curl_easy_setopt(curl, CURLOPT_URL, self.endPoint)
        //curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1)
        response = responseWithInfo(curl)
		curl_easy_cleanup(curl)
        return response
    func responseWithInfo curl{
        res = curl_easy_perform_silent(curl)
        status = curl_getStatusCode(curl)
        ct = curl_getContentType(curl)
        response = new Response
        
        if status = 0 {
            response.statusCode = 404
            response.request = self
            response.endPoint = endPoint
        else
            response.statusCode = status
            response.setHeader("Content-Type", ct)
            response.setBody(res)
            response.request = self
            response.endPoint = endPoint
        }
        
        return response
    }
    func setQuery key, value 
        self.params.query[key] = value
    func setBody cBody 
        self.params.body(cBody)
    func getQuery 
        return self.params.query 
    func getBody 
        return self.params.body
    func setHeader key, value 
        self.hdr[key] = value
    func header key 
        return hdr[key]
   
    private 
        method     = ""
        endPoint   = ""
        q          = ""
        hdr        = []
        velocyPack = false
        params     = NULL
        body       = ""
        curl = NULL
        func prepareQuery 
			count = 1
            query = ""
			for f in params.query
				if count = len(params.query)
					query + = f[1] + "="+ f[2]
				else 
					query + = f[1] + "="+ f[2]+"&"
				ok
			next
 		
			self.endPoint += "?"+ query


}