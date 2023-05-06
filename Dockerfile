# Use Gitea 1.19.0 as base image
FROM gitea/gitea:1.19.0

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

RUN gem install --no-document asciidoctor asciidoctor-pdf asciidoctor-diagram

# Install PlantUML
#See: https://plantuml.com/download
# PROVIDED -- RUN wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" -O /usr/local/bin/plantuml.jar && \
RUN wget "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar" -O /usr/local/bin/plantuml.jar && \
    echo -e '#!/bin/sh\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

RUN mkdir -p /data && chown -R git:git /data
# RUN chown -R git:git /data/gitea/conf/app.ini

#HACK... -_-
COPY custom/app.ini /data/gitea/conf/app_root.ini
USER git
RUN cp /data/gitea/conf/app_root.ini /data/gitea/conf/app.ini
USER root
#FOR GIGGLES:
RUN chown -R git:git /data/gitea/conf/app.ini

EXPOSE 22 3000

# USER root
RUN mkdir -p /app/gitea && chown -R git:git /app/gitea

#USER git

ENTRYPOINT ["/usr/local/bin/gitea"]
CMD ["web"]

#ChatGPT SAYS NO to MySQL!
# BUT ...
# 1) sudo docker pull mariadb:latest
# 2) sudo docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=gitea -e MYSQL_USER=gitea -e MYSQL_PASSWORD=gitea-secret-pw mariadb:latest
# 3) sudo docker run -d --name AsciiTeaParty --link mariadb:mariadb -p 3000:3000 -p 22:22 asciiteaparty:v1_gitea1-19-0

#To Run?
#docker run -d -p 222:22 -p 3000:3000 -v ./data:/app/gitea/data -v ./logs:/app/gitea/logs --name gitea_container your_image_name
