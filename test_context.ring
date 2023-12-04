load "context.ring"
load "stdlib.ring"
func main{
   
    //|# ctx1 = new Context {
    //|#     setSetting("name", "mohammed")
    //|#     getSettings("name")
    //|# }
    //|# ctx2 = withValue(ctx1, "name", "omer")
    //|# ? ctx2.getValue("name")

    //|# ? type(false)

    x = [90, 9]
    ref(x)[1] = 78
    ? x

}




