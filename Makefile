EBIN_DIR=ebin

.PHONY: test clean

#compile: ebin exbin
compile: ebin

ebin: lib/*.ex
	@ rm -f ${EBIN_DIR}/::*.beam
	@ echo Compiling Elixir code ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	elixirc lib/*/*/*.ex lib/*/*.ex lib/*.ex -o $(EBIN_DIR) --docs
	@ echo

#ebin: src/*.erl
#	@ rm -f ${EBIN_DIR}/::*.beam
#	@ echo Compiling Erlang code ...
#	@ mkdir -p $(EBIN_DIR)
#	@ touch $(EBIN_DIR)
#	erlc -o ${EBIN_DIR} src/*.erl
#	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ${EBIN_DIR} -r "test/**/*_test.exs"
	@ echo

clean:
	rm -rf $(EBIN_DIR)
	@ echo
