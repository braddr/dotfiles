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

$(OUTPUTDIR)/.ssh/authorized_keys : src/ssh/authorized_keys
	$(QUIET)echo "Copying $< -> $@"
	$(QUIET)mkdir -p $(dir $@)
	$(QUIET)cat $< >> $@
	$(QUIET)chmod go-rwx $@

$(OUTPUTDIR)/.ssh/config : src/ssh/config
	$(QUIET)echo "Copying $< -> $@"
	$(QUIET)mkdir -p $(dir $@)
	$(QUIET)cp -a $< $@
	$(QUIET)chmod go-rwx $@

copy-files: $(OUTFILES)

diff:
	$(QUIET)for x in $(patsubst src/%,%,$(INFILES)); do diff -u src/$$x $(OUTPUTDIR)/.$$x; done

$(SSHKEYS):
	scp -P 2225 -q braddr@comcast.puremagic.com:~/$@ ~/$@

ssh-keys: $(SSHKEYS)

