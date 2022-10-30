SHELL := /usr/bin/env bash

.PHONY: clean superclean
.DEFAULT_GOAL := submission.zip

SKIPPED := $(subst .skipped,,$(shell ls *.skipped))
QUESTIONS := $(filter-out $(SKIPPED),$(shell echo {A..R}))
QUERIES := $(addsuffix .rq,$(QUESTIONS))
CORRECT := $(addsuffix .correct,$(QUESTIONS))

NG_QS := $(shell echo {A..K})
WD_QS := $(shell echo {L..Q})
NG := https://jena-fuseki.fly.dev/NCG/sparql
WD := https://query.wikidata.org/sparql
service = $(if $(filter $(NG_QS),$(1)),$(NG),$(WD))

clean:
	rm -f *.valid *.correct *.skipped *-actual.csv submission.zip

superclean: clean
	$(MAKE) -s -C tools/jena clean

skipped:
	@echo $(SKIPPED)

tools/jena/bin/qparse \
tools/jena/bin/riot \
tools/jena/bin/rsparql:
	which java || \
	(sudo apt update && sudo apt -y install default-jre)
	$(MAKE) -s -C tools/jena

%.valid: %.rq | tools/jena/bin/qparse
	./tools/jena/bin/qparse --query $<
	touch $@

R-actual.ttl: description.ttl R.rq
	arq --data=$< --query=R.rq --results=ttl > $@

%-actual.csv: %.rq %.valid | tools/jena/bin/rsparql
	rsparql --query $< --service $(call service,$*) --results=CSV > $@

R.correct: R-actual.ttl | tools/jena/bin/riot
	./tools/jena/bin/riot --count $<
	touch $@

%.skipped:
	touch $@

%.correct: %-actual.csv %-expect.csv
	which colordiff || \
	(sudo apt update && sudo apt -y install colordiff)
	colordiff -u $^
	touch $@

submission.zip: $(CORRECT)
ifneq ($(SKIPPED),)
	@echo Skipping the following questions:
	@echo $(SKIPPED)
	@echo -n "Are you sure you want to skip these questions? [Y/n] "
	@read line; \
	if [ "$$line" == "n" ]; then \
	echo ; \
	echo "If you don't want to skip them, run 'make clean'" ; \
	echo "then run 'make submission.zip' again." ; \
	echo ; \
	exit 1 ; \
	fi
endif
	which zip || \
	(sudo apt update && sudo apt -y install zip)
	zip $@ $(QUERIES) description.ttl
