all: sloq.nim
	nim c -d:release sloq.nim

compile: sloq.nim
	nim c sloq.nim

debug: sloq.nim
	nim c -d:nimDebugDlOpen sloq.nim 

test: compile
	cat sample.log | ./sloq

clean:
	$(RM) sloq

