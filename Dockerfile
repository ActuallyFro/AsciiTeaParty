# Use Gitea 1.19.0 as base image
# https://hub.docker.com/r/gitea/gitea/tags?page=1&ordering=last_updated&name=1.19.0
FROM gitea/gitea:1.19.0

USER root
RUN mkdir -p /app/gitea && chown -R git:git /app/gitea
RUN mkdir -p /data/gitea/conf && chown -R git:git /data

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

RUN gem install --no-document asciidoctor asciidoctor-diagram coderay rouge thread_safe


# Install PlantUML
#See: https://plantuml.com/download
# PROVIDED -- RUN wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" -O /usr/local/bin/plantuml.jar && \
RUN wget "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar" -O /usr/local/bin/plantuml.jar && \
    echo -e '#!/bin/sh\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml


#Shoutout to: https://mydeveloperplanet.com/2022/10/19/docker-files-and-volumes-permission-denied/
USER git
COPY --chown=git:git custom/app.ini /data/gitea/conf/app.ini

USER root

EXPOSE 22 3000

ENTRYPOINT ["/usr/local/bin/gitea"]
CMD ["web"]

#Does nothing, makes me feel better:
RUN chown -R git:git /data

#ChatGPT SAYS NO to MySQL!
# BUT ...
# 1) sudo docker pull mariadb:latest
# 2) sudo docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=gitea -e MYSQL_USER=gitea -e MYSQL_PASSWORD=gitea-secret-pw mariadb:latest
# 3) sudo docker run -d --name AsciiTeaParty --link mariadb:mariadb -p 3000:3000 -p 22:22 asciiteaparty:v1_gitea1-19-0

#To Run?
#docker run -d -p 222:22 -p 3000:3000 -v ./data:/app/gitea/data -v ./logs:/app/gitea/logs --name gitea_container your_image_name
