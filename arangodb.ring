load "classes/client_database.ring"
load "classes/database_user.ring"
load "classes/database_options.ring"
load "classes/database_error.ring"
load "classes/database_authentication.ring"
load "classes/client_connection.ring"
load "classes/result.ring"
load "classes/database.ring"
load "classes/cursor.ring"
load "classes/meta.ring"
load "classes/query.ring"
load "classes/collection.ring"
load "classes/json_object.ring"
load "classes/utils.ring"
load "context.ring"
load "http_client.ring"



func  PathJoin clist{
    path = ""
    for i = 1 to  len(clist){
        if i = len(clist){
            path + = clist[i]
        else 
            path + = clist[i]+ "/"
        }
    }
    return path
}