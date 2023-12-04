func inList field, cList{
    if not islist(cList){
        return
    }
    found = false
    for i in cList {
        if field = i or field = i[1]{
            found = true
        }
    }
    return found
}