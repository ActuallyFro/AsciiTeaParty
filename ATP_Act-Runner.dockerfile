# Use Gitea Runner 
#https://hub.docker.com/r/gitea/act_runner -- 6 May 23's nightly is 0.1.7
FROM gitea/act_runner:0.1.7

ENV GITEA_INSTANCE_URL http://127.0.0.1:3000
ENV GITEA_RUNNER_REGISTRATION_TOKEN q7kEro5d1J7R8NMj167o4G8AjY2JRduJNY5rLV0k 

USER root
# RUN mkdir -p /data/gitea/conf && chown -R git:git /data
RUN mkdir -p /data/gitea/conf

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
    wget \
    curl

RUN gem install --no-document asciidoctor asciidoctor-pdf asciidoctor-diagram

# Install PlantUML
#See: https://plantuml.com/download
# PROVIDED -- RUN wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" -O /usr/local/bin/plantuml.jar && \
RUN wget "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar" -O /usr/local/bin/plantuml.jar && \
    echo -e '#!/bin/sh\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

#Runner is in /usr/local/bin/act_runner
# RUN curl https://gitea.com/gitea/act_runner/releases/download/v0.1.7/act_runner-0.1.7-linux-amd64 -o /data/act_runner_0-1-7 && chmod +x /data/act_runner_0-1-7

#Does nothing, makes me feel better:
# RUN chown -R git:git /data

# FROM: https://gitea.com/gitea/act_runner/releases

#To Run?
#giteaBoxIP=$(ip addr show | grep 'inet\b' | awk '{print $2}' | cut -d '/' -f1 | grep -v "127.0.0.1" | head -n 1)
#$giteaBoxPORT=3000
#giteaBoxTOKEN="hLPi41NhM1DYTe9hCaqsZCBVFzw1WuQ0zox5BtVw"
#docker run -e GITEA_INSTANCE_URL=http://$giteaBoxIP:$giteaBoxPORT -e GITEA_RUNNER_REGISTRATION_TOKEN=$giteaBoxTOKEN -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/data:/data --name my_runner atp/runner:v1_gitea1-19-0_0-1-7
#For run -- docker run -e GITEA_INSTANCE_URL=http://$giteaBoxIP:$giteaBoxPORT -e GITEA_RUNNER_REGISTRATION_TOKEN=$giteaBoxTOKEN -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/data:/data --name my_runner gitea/act_runner:nightly