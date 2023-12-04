load "jsonlib.ring"


p = new Person{
    name = new Name{
        f = "Mohammed"
        l = "ahmed"
    }
    age = 26
    addrss = [
        new Address{
            address = "shindi"
            zip = "234"
        }
    ]
}
//? marshal(p)
//? jsonList(["iuiu", "klklk", "l;l;l;"])

func childObject2List v{
    cs = []
    for c in attributes(v)   
        cv = getAttribute(v, c)
        if not isnull(cv){
            if isObject(cv){
                cs[c] = childObject2List(cv)
            else
                cs[c] = cv
            }
        }
    next
    return cs
}
func marshal object{
    json = []
    for a in attributes(object)
        v = getAttribute(object, a)
        if not isNull(v){
            if isObject(v){
                json[a] = childObject2List(v) 
            else
                cv = getAttribute(object, a)
                newList = []
                if isList(cv){
                    for i in cv
                        if isObject(i){
                            newList + childObject2List(i)
                        }  
                    next
                    json[a] = newList
                else
                    json[a] = cv
                }
                
            }
        }
    next
    return list2json(json)
}

func hasAttribute name, obj{
    for a in attributes(obj){
        if a = name{
            return true
        }
    }
    return false
}

func unMarshal json, cObj{
    obj = null
    if not isString(cObj){
         obj =  cObj
    else 
        obj = new from cObj
    }
   
    if not isList(json){
        json = json2list(json)
    }
    for j in json
        if not hasAttribute(j[1], obj){
            addAttribute(obj, j[1])
        }
        ? obj
        setAttribute(obj, j[1], j[2])
    next
    return obj

}

func jsonList list{
    arr = cJSON_CreateArray()
    for i in list {
        row = cJSON_CreateRaw(list2json(i))
        cJSON_AddItemToArray(arr, row)
    }
    return cJSON_Print(arr)
}

class Person{
    name 
    age
    addrss = []
}

class address{
    address 
    zip
}

class name{
    f 
    l
}
