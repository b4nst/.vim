install: ~/.vimrc

~/.vimrc:
	mv $@ $@.bak
	ln -s $(CURDIR)/.vimrc $@
