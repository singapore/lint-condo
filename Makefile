
.PHONY: prepare

prepare:
	apt-get install python3-pip
	pip3 install --upgrade pathlib
	pip3 install --upgrade doit
	doit tabcompletion > /etc/bash_completion.d/doit
