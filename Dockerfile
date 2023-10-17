FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and GitLab Runner
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y openssh-client && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash && \
    apt-get install -y gitlab-runner && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install GitLab Runner
RUN curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb" && \
    dpkg -i gitlab-runner_amd64.deb && \
    rm gitlab-runner_amd64.deb

# Install dumb-init
RUN curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/bin/dumb-init

# Register GitLab Runner using the custom registration script
RUN chmod +x /etc/gitlab-runner/util/registration.sh && \
    gitlab-runner register --non-interactive \
        --url "https://gitlab.com/" \
        --registration-token "GR1348941zC4woTTKAatgv9r6Yptx" \
        --executor "shell" \
        --name "kubernetes-master" \
        --tag-list "kubernetes" \
        --run-untagged="true" \
        --locked="false" \
        --access-level="not_protected"

RUN mkdir -p /etc/ssl/runner-cacert
COPY cacert.crt /etc/ssl/runner-cacert/cacert.crt

COPY config.toml /etc/gitlab-runner/util/config.toml
COPY /etc/gitlab-runner/util/config.toml /etc/gitlab-runner/config.toml

COPY /etc/ssl/runner-cacert/cacert.crt /etc/gitlab-runner/config.toml

RUN awk '/token/ {print $3}' /etc/gitlab-runner/config.toml > /etc/gitlab-runner/util/config.toml

RUN awk '/token/ {print $3}' /etc/gitlab-runner/config.toml/config.toml

# Entrypoint
ENTRYPOINT ["gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
