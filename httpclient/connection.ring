
class Connection{
    baseUrl
    func init opts{
        self.baseUrl = opts[:baseUrl]
        return self
    }
    func Request method, path{
		endPoint = baseUrl + path
        request = new Request(endPoint, method, [], new Params)
        return request
    }
    func DoRequest req{
       return req.PerfomeRequest()
    }
}