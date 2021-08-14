sloq_bin="bin/sloq"
sloq_debug_bin="bin/sloq_debug"

all: src/sloq.nim src/db_con.nim
	nim c -d:release -o:$(sloq_bin) src/sloq.nim && chmod 755 $(sloq_bin)

debug: src/sloq.nim src/db_con.nim
	nim c --debuginfo:on -o:$(sloq_debug_bin) src/sloq.nim && chmod 755 $(sloq_debug_bin)
