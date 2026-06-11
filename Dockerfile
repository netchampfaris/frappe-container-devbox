FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV container=container
ENV PATH=/root/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin
ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python
ENV UV_TOOL_DIR=/opt/uv/tools
ENV UV_TOOL_BIN_DIR=/usr/local/bin

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      sudo \
      systemd \
      systemd-sysv \
      dbus \
      cron \
      git \
      build-essential \
      pkg-config \
      python3-dev \
      python3-venv \
      python3-pip \
      libmariadb-dev \
      libffi-dev \
      libssl-dev \
      redis-server \
      xvfb \
      libfontconfig \
      fonts-dejavu-core \
      fontconfig \
      vim-tiny \
      jq \
      net-tools \
      iproute2 \
      iputils-ping \
      procps \
      wget && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | \
      bash -s -- --mariadb-server-version=11.8 && \
    apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server mariadb-client libmariadb-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    install -m 0755 /root/.local/bin/uv /usr/local/bin/uv && \
    install -m 0755 /root/.local/bin/uvx /usr/local/bin/uvx && \
    uv python install 3.14 --default && \
    PY314="$(uv python find 3.14)" && \
    ln -sf "$PY314" /usr/local/bin/python3.14 && \
    chmod -R a+rX /opt/uv

RUN git clone --depth 1 https://github.com/frappe/bench-cli /opt/bench-cli && \
    chmod +x /opt/bench-cli/bench && \
    ln -sf /opt/bench-cli/bench /usr/local/bin/bench && \
    mkdir -p /opt/bench-cli/benches

RUN systemctl set-default multi-user.target && \
    : > /etc/machine-id && \
    : > /var/lib/dbus/machine-id && \
    test -x /sbin/init

COPY scripts/frappe-devbox-init /usr/local/bin/frappe-devbox-init
COPY scripts/create-frappe-bench /usr/local/bin/create-frappe-bench
COPY scripts/start-frappe /usr/local/bin/start-frappe

RUN chmod +x \
      /usr/local/bin/frappe-devbox-init \
      /usr/local/bin/create-frappe-bench \
      /usr/local/bin/start-frappe

WORKDIR /opt/bench-cli/benches
