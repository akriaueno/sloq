# sloq
slow query analyzer

(under development (MYSQL slow query log only))

## Features
- Show slow queries.
- Connect DBMS and execute `EXPLAIN` for slow queries.

## Installation
### Dependency
`libmysqlclient`

### Build
```bash
sudo apt install default-libmysqlclient-dev
make
```

## Usage
```bash
cat slow.log | DB_USER=root DB_PASSWORD=password DB_NAME=mysql ./sloq
```
