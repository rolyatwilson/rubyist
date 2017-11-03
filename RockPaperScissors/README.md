# Rock Paper Scissors
Examples for a server/client game of Rock Paper Scissors.

## Setup
```bash
bundle install
```

## Server
The server must be running before launching clients.
The server has multiple threading examples that can be
executed by specifying the example `-e` option. The
port `-p` may also be specified.

```bash
./bin/rockpaperscissors server -p 8888 -e 1

# or

./bin/rockpaperscissors server -p 8888 -e 2

# or

./bin/rockpaperscissors server -p 8888 -e 3
```

## Client
The client can be launched, in multiple terminals.
This client does not have a `-e` option; it should work
with each server example. You may specify the server 
host `-h` and port `-p` options.

```bash
./bin/rockpaperscissors client -h localhost -p 8888
```
