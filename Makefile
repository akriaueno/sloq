all: sloq.nim
	nim c -d:release sloq.nim

compile: sloq.nim
	nim c sloq.nim

test: compile
	cat sample.log | ./sloq

clean:
	$(RM) sloq

