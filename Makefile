all: copy-files

QUIET=@
OUTPUTDIR=~
INFILES=$(wildcard src/*)
OUTFILES=$(patsubst src/%,$(OUTPUTDIR)/.%,$(INFILES))

$(OUTPUTDIR)/.% : src/%
	$(QUIET)echo Copying $< -> $@
	$(QUIET)cp $< $@

copy-files: $(OUTFILES)

diff:
	$(QUIET)for x in $(patsubst src/%,%,$(INFILES)); do diff -u src/$$x $(OUTPUTDIR)/.$$x; done

