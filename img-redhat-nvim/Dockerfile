FROM registry.access.redhat.com/ubi9/ubi

RUN dnf -y update && \
    dnf -y install \
      less \
      git \
      procps-ng \
      which \
      findutils \
      shadow-utils && \
    dnf clean all

WORKDIR /workspace

CMD ["/bin/bash"]
