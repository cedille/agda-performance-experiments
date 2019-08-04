AGDA=agda

SRCDIR=src

SRC = $(wildcard src/*.agda)
OBJ = $(SRC:%.agda=%.agdai)

LIB = --library-file=libraries --library=ial --library=agda-perf

all: test1

libraries: ./ial/ial.agda-lib
	rm -f $@ && for f in src/agda-perf.agda-lib ial/ial.agda-lib ; do echo "`pwd`/$$f" >> libraries;	done

./ial/ial.agda-lib:
	git submodule update --init --recursive

CEDILLE_DEPS = $(SRC) Makefile libraries ./ial/ial.agda-lib
CEDILLE_BUILD_CMD = $(AGDA) $(LIB) --ghc-flag=-rtsopts 
CEDILLE_BUILD_CMD_DYN = $(CEDILLE_BUILD_CMD) --ghc-flag=-dynamic 

test1:	$(CEDILLE_DEPS)
		echo $(CEDILLE_DEPS)
		$(CEDILLE_BUILD_CMD_DYN) -c $(SRCDIR)/main.agda
		mv $(SRCDIR)/main $@

# cedille-static: 	$(CEDILLE_DEPS)
# 		$(CEDILLE_BUILD_CMD) --ghc-flag=-optl-static --ghc-flag=-optl-pthread -c $(SRCDIR)/main.agda
# 		mv $(SRCDIR)/main $@

# cedille-profile:	$(CEDILLE_DEPS)
# 		$(CEDILLE_BUILD_CMD) --ghc-flag=-prof --ghc-flag=-fprof-auto --ghc-flag=-fexternal-interpreter -c $(SRCDIR)/main.agda
# 		mv $(SRCDIR)/main $@

# cedille-optimized:	$(CEDILLE_DEPS)
# 		$(CEDILLE_BUILD_CMD) --ghc-flag=-O2 -c $(SRCDIR)/main.agda
# 		mv $(SRCDIR)/main $@

.PHONY: clean-ial
clean-ial:
	make -C ial clean

clean:
	git clean -Xfd # only remove .gitignore files and directories

