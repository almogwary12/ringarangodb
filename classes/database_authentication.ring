
class AuthType{
    type
}
class userNameAuthentication {
    username
    password
    type
    func init username, password{
        self.username = username
        self.password = password 
        return self
    }
    func getType{
        return type
    }
}

class JWTAuthentication from userNameAuthentication{
    func init username, password{
        super.init(username, password)
        type = new AuthType{
            type = "JWT"
        }
        return self
    }
    
}

class BasicAuthentication from userNameAuthentication{
    func init username, password{
        super.init(username, password)
        type = new AuthType{
            type = "Basic"
        }
        return self
    }  
}

class User{
    username
    password
    active
}