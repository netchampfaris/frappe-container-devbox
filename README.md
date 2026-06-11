# Frappe v16 Apple Container Devbox

One-command Frappe v16 devbox setup using Apple `container machine` and [`frappe/bench-cli`](https://github.com/frappe/bench-cli).

This does not use `frappe_docker` or Docker Compose.

## Requirements

- Apple Silicon Mac
- macOS 26
- macOS administrator password
- Strong internet connection
- At least 16 GB RAM recommended
- Around 30-40 GB free disk space recommended

The setup script installs Apple `container` 1.0.0 automatically if it is missing.

## Setup

```bash
./setup
```

Setup asks where the `frappe-bench` directory should live on your Mac. Choose a path under your home directory, for example:

```text
/Users/you/frappe-bench
```

You can open that folder directly in your editor. The container machine sees it through its home mount.

Setup pulls the published image by default:

```text
ghcr.io/netchampfaris/frappe-devbox:v16
```

To build locally instead:

```bash
FRAPPE_BUILD_LOCAL=1 ./setup
```

## Enter The Devbox

```bash
./frappe-shell
```

This boots the machine if needed, starts MariaDB/Redis/cron, wires your selected host folder into bench-cli's `benches/frappe-bench`, and drops you into an interactive shell.

## First Bench

Inside `./frappe-shell`:

```bash
bench new frappe-bench
bench init
bench new-site site1.localhost
bench start
```

bench-cli references:

- App: `http://site1.localhost:8000`
- Admin UI: `http://localhost:8002`

If `bench init` or `bench start` appears quiet during package installation, let it run.

## Configuration

Override defaults with environment variables:

```bash
FRAPPE_MACHINE_NAME=my-workshop \
FRAPPE_BENCH_NAME=frappe-bench \
FRAPPE_CPUS=8 \
FRAPPE_MEMORY=16G \
./setup
```

Recreate the machine:

```bash
FRAPPE_RECREATE_MACHINE=1 ./setup
```

## Publish Image To GitHub

The GitHub Actions workflow publishes:

- `ghcr.io/netchampfaris/frappe-devbox:v16`
- `ghcr.io/netchampfaris/frappe-devbox:latest`
- `ghcr.io/netchampfaris/frappe-devbox:<commit-sha>`

Run `Publish Devbox Image` from GitHub Actions after changes to the Dockerfile or scripts.
