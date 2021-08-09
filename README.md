# sloq
slow query analyzer

(under development (and support only MySQL slow query log))

## Features
- Show slow queries.
- Connect DBMS and execute `EXPLAIN` for slow queries.

## Installation
### Dependency
`libmysqlclient`

### Build
You need to install `nim` to build.([nim official](https://nim-lang.org/))
```bash
sudo apt install default-libmysqlclient-dev
make
```

## Usage
```bash
cat slow.log | DB_USER=root DB_PASSWORD=password DB_NAME=mysql ./bin/sloq
```
