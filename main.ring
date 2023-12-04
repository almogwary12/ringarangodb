load "arangodb.ring"

// client Databse Configurations
t = clock()
_config = new ClientDatabaseConfig{
	connection = newConnection([
		:endPoint = "http://localhost:8529",
		:authentication = new JWTauthentication("root", "")
	])
}

// create new Client Database object
client = new ClientDatabase(_config)

//check the existence the databse by passing the name  of the  databse
if  client.DatabaseExists(null, "test"){

	// create database object 
	db = client.Database(null, "test")
	//check the collection existence
	if db.collectionExists(null, "users"){

		//create collection object by passing the existing collection name
		users = db.collection(null, "users")
		? users.ImportDocuments(new TodoContext, [[:name = "mona"], [:name = "ata"]], null)

	}
}
? ( clock() - t) / clocksperSecond()