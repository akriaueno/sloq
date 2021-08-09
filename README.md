# sloq
slow query analyzer

(under development (only MYSQL slow query log))

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
cat slow.log | ./sloq
```
