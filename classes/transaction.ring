TransactionRunning    = "running"
TransactionCommitted  = "committed"
TransactionAborted    = "aborted"

class BeginTransactionOptions  {
	WaitForSync        
	AllowImplicit      
	LockTimeout        
	MaxTransactionSize 
}

class beginTransactionRequest  {
	WaitForSync        
	AllowImplicit     
	LockTimeout      
	MaxTransactionSize 
	Collections 
}

class TransactionCollections  {
	Read      = []
	Write     = []
	Exclusive = []
}

class TransactionOptions {
	MaxTransactionSize 
	LockTimeout 
	WaitForSync
	IntermediateCommitCount
	Params = [] 
	IntermediateCommitSize 
	ReadCollections = []
	WriteCollections = []
	ExclusiveCollections = []
}

class TransactionRequest  {
	MaxTransactionSize     
	LockTimeout             
	WaitForSync             
	IntermediateCommitCount             
	Params                  
	IntermediateCommitSize  
	Action                 
	Collections            
}
