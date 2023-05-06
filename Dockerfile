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

# Install Asciidoctor, Asciidoctor-PDF, and Asciidoctor-Diagram
RUN gem install --no-document asciidoctor asciidoctor-pdf asciidoctor-diagram

# Install PlantUML
#See: https://plantuml.com/download
# PROVIDED -- RUN wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" -O /usr/local/bin/plantuml.jar && \
RUN wget "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar" -O /usr/local/bin/plantuml.jar && \
    echo -e '#!/bin/sh\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Copy custom configuration file
COPY custom/app.ini /data/gitea/conf/app.ini

# Expose Gitea ports
EXPOSE 22 3000

# Create a non-root user and switch to that user
RUN adduser -D -u 2000 giteauser
USER giteauser

# Set entrypoint for Gitea
ENTRYPOINT ["/usr/local/bin/gitea"]
CMD ["web"]
