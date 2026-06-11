# Frappe v16 Apple Container Devbox

One-command Frappe v16 development setup using Apple `container machine`.

This does not use `frappe_docker` or Docker Compose. It builds a persistent Linux devbox image with MariaDB, Redis, Python 3.14, Node 24, Yarn, and Bench, then creates a Frappe v16 bench/site inside the machine.

## Requirements

- Apple Silicon Mac
- macOS 26
- macOS administrator password
- Strong internet connection
- At least 16 GB RAM recommended
- Around 15-25 GB free disk space recommended

The setup script installs Apple `container` 1.0.0 automatically if it is missing.

## Setup

```bash
./setup
```

The first run can take a while because it installs Apple `container`, builds the devbox image, downloads Python/Node/MariaDB packages, clones Frappe, and creates the site.

## Start Frappe

```bash
container machine run -n frappe-v16 -- start-frappe frappe-bench
```

During setup, `bench init` can spend several minutes at Yarn's `Building fresh packages` step without printing progress. Let it run.

Then open the machine IP on port `8000`. If DNS is not configured, get the IP with:

```bash
container machine inspect frappe-v16
```

The setup marks the created site as Bench's default site, so opening `http://<machine-ip>:8000` should route to it.

Defaults:

- Machine: `frappe-v16`
- Image: `local/frappe-devbox:v16`
- Bench: `~/frappe/frappe-bench`
- Site: `development.localhost`
- Administrator password: `admin`
- MariaDB root password: `root`

## Configuration

Override defaults with environment variables:

```bash
FRAPPE_MACHINE_NAME=my-client \
FRAPPE_BENCH_NAME=my-bench \
FRAPPE_SITE_NAME=my-client.localhost \
FRAPPE_CPUS=8 \
FRAPPE_MEMORY=16G \
./setup
```

For workshops, prebuild and push the image once, then students can skip the local image build:

```bash
FRAPPE_IMAGE_NAME=ghcr.io/your-org/frappe-devbox:v16 \
FRAPPE_SKIP_BUILD=1 \
./setup
```

## Publish Image To GitHub

Push this folder to a GitHub repo and run the `Publish Devbox Image` workflow from the Actions tab.

The workflow publishes:

- `ghcr.io/<owner>/frappe-devbox:v16`
- `ghcr.io/<owner>/frappe-devbox:latest`
- `ghcr.io/<owner>/frappe-devbox:<commit-sha>`

For the workshop, students should run:

```bash
FRAPPE_IMAGE_NAME=ghcr.io/<owner>/frappe-devbox:v16 \
FRAPPE_SKIP_BUILD=1 \
./setup
```

If the package is private, make it public from GitHub: profile/org packages → `frappe-devbox` → Package settings → Change visibility → Public.

By default this uses Frappe `version-16`. Override with:

```bash
FRAPPE_BRANCH=develop ./setup
```

## Notes

- The bench is created inside the persistent container machine, not in a disposable container.
- MariaDB, Redis, and cron are systemd services inside the machine.
- The setup script is idempotent: it reuses an existing machine and bench/site when present.
