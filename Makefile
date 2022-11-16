# Creative Commons Attribution 4.0 International License
# https://creativecommons.org/licenses/by/4.0/

# this Makefile contains targets for use inside the Docker container and on the baremetal host

mytag=workflow_demo

# what is available?
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make docker"
	@echo "         build and run"
	@echo "==== Targets inside container ===="
	@echo "make doctest"
	@echo "make mypy"


# intended to be run on the host only
docker: docker_build docker_run
docker_build:
	time docker build -f Dockerfile -t $(mytag) .
docker_run:
	docker run -it -v `pwd`:/scratch --rm --workdir /scratch $(mytag) /bin/bash

# the following targets are intended to be run inside the Docker container

# https://mypy.readthedocs.io/en/stable/
# Mypy is a static type checker
mypy:
	mypy --check-untyped-defs run_workflow.py

# https://pycallgraph.readthedocs.io/en/master/
# creates call graph visualizations
pycallgraph:
	pycallgraph graphviz -- ./run_workflow.py

# http://prospector.landscape.io/en/master/
# analyze Python code and output information about errors, 
# potential problems, convention violations and complexity.
prospector:
	prospector

# https://flake8.pycqa.org/en/latest/
# enforce style consistency across Python projects.
flake8:
	flake8 --ignore W291,E115,E121,E122,E124,E126,E127,E128,E203,E221,E225,E231,E241,E251,E261,E265,E302,E303,E501,E701
# E115 expected an indented block
# E121 continuation line under-indented for hanging indent
# E122 continuation line missing indentation or outdented
# E124 closing bracket does not match visual indentation
# E126 continuation line over-indented for hanging indent
# E127 Continuation line over-indented for visual indent; https://www.flake8rules.com/rules/E127.html
# E128 continuation line under-indented for visual indent
# E203 whitespace before
# E221 multiple spaces before operator
# E225 missing whitespace around operator
# E231 missing whitespace after ','
# E241 multiple spaces after ','
# E251 unexpected spaces around keyword / parameter equals
# E261 at least two spaces before inline comment
# E265 block comment should start with '# '
# E302 Expected 2 blank lines, found 0; https://www.flake8rules.com/rules/E302.html
# E303 too many blank lines
# E501 Line too long; https://www.flake8rules.com/rules/E501.html
# E701 Multiple statements on one line; https://www.flake8rules.com/rules/E701.html

# https://black.readthedocs.io/en/stable/
# By using Black, you agree to cede control over minutiae of hand-formatting.
black:
	black run_workflow.py

# https://www.pylint.org/
# http://pylint.pycqa.org/en/latest/
# checks for errors in Python code, tries to enforce a coding standard and looks for code smells.
pylint:
	pylint $(FILE_NAME)

# https://docs.python.org/3/library/doctest.html
# searches for pieces of text that look like interactive Python sessions, and 
# then executes those sessions to verify that they work exactly as shown.
doctest:
	python3 -m doctest -v $(FILE_NAME)

# https://pypi.org/project/mccabe/
# check McCabe complexity; see
# https://en.wikipedia.org/wiki/Cyclomatic_complexity
mccabe:
	python3 -m mccabe $(FILE_NAME)

clean:
	rm -rf .mypy_cache

