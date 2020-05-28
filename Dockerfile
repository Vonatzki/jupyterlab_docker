FROM jupyter/datascience-notebook:latest

ENV GRANT_SUDO yes
ENV JUPYTER_ENABLE_LAB yes

# Install VIM
USER root
RUN apt update \
    && apt install -yqq vim \
    && apt install -yqq openjdk-8-jre-headless

# Switch back to jovyan user
USER jovyan

# Install Jupyterlab Plugins
RUN jupyter labextension install @jupyterlab/toc

# Install pyspark
RUN pip install pyspark

# Install plotly and integrate with Jupyterlab
RUN pip install plotly dash \
# Avoid "JavaScript heap out of memory" errors during extension installation
&& export NODE_OPTIONS=--max-old-space-size=4096 \
# Jupyter widgets extension
&& jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build \
# jupyterlab renderer support
&& jupyter labextension install jupyterlab-plotly@4.6.0 --no-build \
# FigureWidget support
&& jupyter labextension install plotlywidget@4.6.0 --no-build \
# Build extensions (must be done to activate extensions since --no-build is used above)
&& jupyter lab build
