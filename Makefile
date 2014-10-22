REPO            ?= riak
PKG_REVISION    ?= $(shell git describe --tags)
PKG_BUILD        = 1
BASE_DIR         = $(shell pwd)
ERLANG_BIN       = $(shell dirname $(shell which erl))
REBAR           =  rebar
OVERLAY_VARS    ?=

$(if $(ERLANG_BIN),,$(warning "Warning: No Erlang found in your path, this will probably not work"))

.PHONY: rel stagedevrel deps redo delete_arachnid get_arachnid

all: deps compile

redo:	delete_arachnid deps compile generate
	@echo "done"

delete_arachnid:
	rm -rf deps/arachnid

compile:
	$(REBAR) compile

deps:
	$(REBAR) get-deps

clean: testclean
	$(REBAR) clean

distclean: clean devclean relclean ballclean
	$(REBAR) delete-deps

generate:
	$(REBAR)  --force generate $(OVERLAY_VARS)


##
## Release targets
##
rel: deps compile generate

relclean:
	rm -rf rel/riak
