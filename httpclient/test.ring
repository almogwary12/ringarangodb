load "http_client.ring"
con = new Connection([
    :baseUrl = "http://localhost:8529/l;"
])


req = con.Request("GET", "")
? con.DoRequest(req)