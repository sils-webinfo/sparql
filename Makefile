SHELL := /usr/bin/env bash

.PHONY: clean superclean copy check
.DEFAULT_GOAL := submission.zip

SKIPPED := $(subst .skipped,,$(shell ls *.skipped 2> /dev/null))
QUESTIONS := $(filter-out $(SKIPPED),$(shell echo {A..R}))
QUERIES := $(addsuffix .rq,$(QUESTIONS))
CORRECT := $(addsuffix .correct,$(QUESTIONS))

SUBMITTERS := $(shell ls submissions 2> /dev/null)
Q_FEEDBACK := $(foreach S,$(SUBMITTERS),$(foreach Q,$(shell echo {A..Q}),submissions/$S/$Q.md))
S_FEEDBACK := $(foreach S,$(SUBMITTERS),submissions/$S/feedback.md)

NG_QS := $(shell echo {A..K})
WD_QS := $(shell echo {L..Q})
NG := https://jena-fuseki.fly.dev/ncg/sparql
NGQ := https://jena-fuseki.fly.dev/\#/dataset/ncg/query?query=
WD := https://query.wikidata.org/sparql
WDQ := https://query.wikidata.org/\#
service = $(if $(filter $(NG_QS),$(1)),$(NG),$(WD))
queryui = $(if $(filter $(NG_QS),$(1)),$(NGQ),$(WDQ))

.PRECIOUS: %.valid %-actual.csv

grades.csv: $(Q_FEEDBACK) $(S_FEEDBACK)
	echo "username,grade,comment" > $@
	for s in $(SUBMITTERS) ; do \
	  comment=$$(cat submissions/$$s/feedback.md | sed -e 's|"|""|g') ; \
	  echo "$$s,P,\"$$comment\"" >> $@ ; \
	done

clean:
	rm -f *.valid *.correct *.skipped *-actual.csv submission.zip
	find -L submissions -name '*.md' -exec rm -f {} \;
	find -L submissions -name '*.parsed' -exec rm -f {} \;

superclean: clean
	$(MAKE) -s -C tools/jena clean

skipped:
	@echo $(SKIPPED)

tools/jena/bin/arq \
tools/jena/bin/qparse \
tools/jena/bin/riot \
tools/jena/bin/rsparql:
	which java || \
	(sudo apt update && sudo apt -y install default-jre)
	$(MAKE) -s -C tools/jena

%.parsed: %.rq | tools/jena/bin/qparse
	./tools/jena/bin/qparse --query $< > $@

submissions/%.md:
	echo "#### $(word 2,$(subst /, ,$*))" > $@
	echo "" >> $@
	showquery=false ; \
	if [ -f submissions/$*.rq ]; then \
	  $(MAKE) submissions/$*.parsed ; \
	  $(MAKE) answers/$(word 2,$(subst /, ,$*)).parsed ; \
	  if cmp submissions/$*.parsed answers/$(word 2,$(subst /, ,$*)).parsed ; then \
	    echo "Perfect!" >> $@ ; \
	  else \
	    echo "Nice work! My query was slightly different, but the two queries produced the same results in this case:" >> $@ ; \
	    showquery=true ; \
	  fi ; \
	else \
	  echo "This one was tough. Here's how I did it:" >> $@ ; \
	  showquery=true ; \
	fi ; \
	if [ "$$showquery" = true ] ; then \
	  query=$$(cat answers/$(word 2,$(subst /, ,$*)).rq) ; \
	  encquery=$$(echo "$$query" | jq -sRr '@uri') ; \
	  echo "" >> $@ ; \
	  echo '```' >> $@ ; \
	  echo "$$query" >> $@ ; \
	  echo '```' >> $@ ; \
	  echo "" >> $@ ; \
	  echo "[Try this query]($(call queryui,$(word 2,$(subst /, ,$*)))$$encquery)" >> $@ ; \
	  echo "" >> $@ ; \
	fi
	echo "" >> $@

submissions/%/feedback.md:
	cat submissions/$*/*.md > $@

%.valid: %.rq | tools/jena/bin/qparse
	./tools/jena/bin/qparse --query $<
	touch $@

R-actual.ttl: description.ttl R.rq | tools/jena/bin/arq
	./tools/jena/bin/arq --data=$< --query=R.rq --results=ttl > $@

%-actual.csv: %.rq %.valid | tools/jena/bin/rsparql
	./tools/jena/bin/rsparql --query $< --service $(call service,$*) --results=CSV > $@

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

copy: clean
	rm -f *.rq
	cp -f submissions/$(WHO)/*.rq .
	cp -f submissions/$(WHO)/description.ttl .

check: $(CORRECT)
	cat R.rq
	echo
	cat R-actual.ttl
