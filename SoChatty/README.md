# SoChatty
Examples for date/time and chat servers using threads.

## Setup
```bash
bundle install
```

## Server Startup
The server must be running before attempting to run the clients.
Specify which port the server should use with the `-p` options.
```bash
./bin/sochatty server -p 8888
```

## Client Startup
Launch the client with optional host `-h` and port `-p` options.
```bash
./bin/sochatty client -h localhost -p 8888
```

## Examples
Both the server and client have various examples that can be
run by specifying the example `-e` option. You must use the 
same option for both the server and client:
```bash
./bin/sochatty server -p 8888 -e 1
./bin/sochatty client -p 8888 -e 1

# or

./bin/sochatty server -p 8888 -e 2
./bin/sochatty client -p 8888 -e 2

# or

./bin/sochatty server -p 8888 -e 3
./bin/sochatty client -p 8888 -e 3

# etc.
```
