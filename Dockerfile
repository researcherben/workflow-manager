# Creative Commons Attribution 4.0 International License
# https://creativecommons.org/licenses/by/4.0/

# Use baseimage-docker which is a modified Ubuntu specifically for Docker
# https://hub.docker.com/r/phusion/baseimage
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:0.11

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Update and install packages
RUN apt update && apt -y upgrade && apt -y install \
    doxygen \
    python3 \
    # doxygen uses "dot" to make graphs
    graphviz \
    # doxygen PDF requires latex
    texlive-latex-base \
    texlive-latex-recommended texlive-pictures texlive-latex-extra \
    # doxygen latex requires make
    make \
    # sphinx is a pip package
    python3-pip

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt 


WORKDIR /opt/

COPY run_workflow.py \
     file.json \
     config_schema.json \
     /opt/

# https://www.doxygen.nl/manual/starting.html
RUN doxygen -g

# https://stackoverflow.com/questions/4755913/how-to-use-doxygen-to-create-uml-class-diagrams-from-c-source
RUN sed -i 's/^EXTRACT_ALL.*/EXTRACT_ALL = YES/' Doxyfile && \
    sed -i 's/^UML_LOOK.*/UML_LOOK = YES/' Doxyfile && \
    sed -i 's/^RECURSIVE.*/RECURSIVE = YES/' Doxyfile && \
    sed -i 's/^GENERATE_TREEVIEW.*/GENERATE_TREEVIEW = YES/' Doxyfile && \
    sed -i 's/^SOURCE_BROWSER.*/SOURCE_BROWSER = YES/' Doxyfile && \
    sed -i 's/^CALL_GRAPH.*/CALL_GRAPH = YES/' Doxyfile && \
    sed -i 's/^CALLER_GRAPH.*/CALLER_GRAPH = YES/' Doxyfile && \
    sed -i 's/^HIDE_UNDOC_RELATIONS.*/HIDE_UNDOC_RELATIONS = NO/' Doxyfile

RUN doxygen Doxyfile

WORKDIR /opt/latex/
RUN make

# end of Doxygen

WORKDIR /opt/

# sphinx documentation
RUN sphinx-quickstart . --sep --project "py-interface" --author "Ben" --no-batchfile --quiet
RUN make latex
RUN make html


WORKDIR /opt/source/
RUN sed -i '13 i .. automodule:: produce_output' index.rst
RUN sed -i '14 i     :members:' index.rst
RUN sed -i '15 i     :undoc-members:' index.rst
RUN sed -i '16 i     :show-inheritance:' index.rst

RUN sed -i "31 i    'sphinx.ext.doctest'," conf.py
RUN sed -i "31 i    'sphinx.ext.todo'," conf.py
RUN sed -i "31 i    'sphinx.ext.autosummary'," conf.py
RUN sed -i "31 i    'sphinx.ext.autodoc'," conf.py
RUN sed -i "31 i    'sphinx.ext.coverage'," conf.py
RUN sed -i "31 i    'sphinx.ext.mathjax'," conf.py
RUN sed -i "31 i    'sphinx.ext.viewcode'," conf.py
RUN sed -i "31 i    'sphinx.ext.githubpages'" conf.py

WORKDIR /opt/build/latex
RUN pdflatex py-interface
RUN pdflatex py-interface


WORKDIR /opt
