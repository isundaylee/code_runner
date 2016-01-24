# Code Runner

Code Runner is a simple Sinatra app that runs scripts (currently supports Ruby and Python) and returns the output (stdout, stderr, as well as status code) in JSON format. 

# Usage

To run the server, 

```
rackup -p 3000
```

To run code, simply make a POST request to the root URL, with the parameter `code` being the file that you want to run. For example, 

```
curl "localhost:3000" -F "code=@/somewhere/hello_world.py"
```

would give

```
{"stdout":"Hello, world! \n","stderr":"","status":0,"success":true}
```
