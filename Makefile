all: copy-files

QUIET=@
OUTPUTDIR=~
INFILES=$(shell find src -type f -and ! -name \*.sw[a-z])
OUTFILES=$(patsubst src/%,$(OUTPUTDIR)/.%,$(INFILES))
SSHKEYS=$(addprefix .ssh/,id_rsa github.rsa cygwin-keypair-one.pem)

$(OUTPUTDIR)/.% : src/%
	$(QUIET)echo "Copying $< -> $@"
	$(QUIET)mkdir -p $(dir $@)
	$(QUIET)cp -a $< $@

copy-files: $(OUTFILES)

diff:
	$(QUIET)for x in $(patsubst src/%,%,$(INFILES)); do diff -u src/$$x $(OUTPUTDIR)/.$$x; done

$(SSHKEYS):
	scp -q braddr@redmond.puremagic.com:~/$@ ~/$@

ssh-keys: $(SSHKEYS)

