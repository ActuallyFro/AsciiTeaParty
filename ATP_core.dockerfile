# PLACE ALL NEEDED CORE, SOFTWARE HERE for ASCIIDOCTOR
#AsciiTeaParty - Core - 0.1.0
#Enable FROM gitea/gitea:1.19.0 and gitea/act_runner:0.1.7
FROM alpine:3.17.2
USER root
# RUN mkdir -p /app/atp && chown -R git:git /app/atp

# Install dependencies for Asciidoctor, Asciidoctor-PDF, Asciidoctor-Diagram, and PlantUML
RUN apk add --no-cache \
    ruby \
    ruby-dev \
    build-base \
    libc-dev \
    libxml2-dev \
    libxslt-dev \
    openjdk11-jre \
    graphviz \
    ttf-dejavu \
    wget

RUN gem install --no-document asciidoctor asciidoctor-diagram asciidoctor-pdf coderay rouge thread_safe

# Install PlantUML
#See: https://plantuml.com/download
# PROVIDED -- RUN wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" -O /usr/local/bin/plantuml.jar && \
RUN wget "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar" -O /usr/local/bin/plantuml.jar && \
    echo -e '#!/bin/sh\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# #Does nothing, makes me feel better:
# RUN chown -R git:git /app
