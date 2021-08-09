all: src/sloq.nim src/db_con.nim
	nim c -d:release -o:bin/sloq src/sloq.nim

