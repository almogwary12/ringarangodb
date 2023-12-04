class Params 
	body  =	[]  
	query = []
	func body body 
        if isString(body){
            self.body  = body
        else 
            self.body = trim(list2json(body))
        }
		
	func query query
		self.query = query