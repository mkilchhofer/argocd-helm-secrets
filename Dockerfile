FROM quay.io/argoproj/argocd:v2.3.4

ARG SOPS_VERSION="3.7.2"
ARG HELM_SECRETS_VERSION="3.12.0"
ARG KUBECTL_VERSION="1.22.7"

USER root
RUN apt-get update && \
    apt-get install -y \
      curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -fSSL https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux \
    -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops
RUN curl -fSSL https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

ENV HELM_PLUGINS="/usr/local/share/helm/plugins"
RUN mkdir -p ${HELM_PLUGINS} && \
    helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets

USER 999
