# cloudnotes-infra-lab

A small, self-contained "broken repo" for the Cloud Computing Module 3
assessment. Everything here runs **locally at ₹0 / $0** — no cloud
account, no paid registry, no login, no real credentials. Target
completion time is **30–40 minutes**.

## Before you start: fork, then clone

Do **not** clone this repository directly. Fork it first so your
fixes go into your own copy:

1. Click **Fork** on this repository on GitHub.
2. Clone **your fork** (not this original repo):

   ```bash
   git clone https://github.com/<your-username>/cloudnotes-infra-labs.git
   cd cloudnotes-infra-labs
   git checkout -b fix/cloudnotes-release
   ```

Everything below assumes you are working inside your fork.

## What this repo contains

```text
cloudnotes-infra-lab/
├── app/                          # tiny Flask health-check service
├── terraform/                    # local/mock-safe Terraform (no cloud provider)
│   └── modules/cloudnotes-service/
├── security/check.sh             # local security check, no login needed
├── Dockerfile                    # multi-stage build, non-root runtime
├── compose.yaml                  # api + local registry, port 8080:5000
├── .env.example                  # fake values only, copy to .env
├── .gitignore / .dockerignore
└── release-notes.md              # fill this in as evidence
```

- `GET /health` on the Flask app returns `{"service":"cloudnotes-api","status":"ok"}` with HTTP 200.
- Compose exposes the API on **`http://localhost:8080`**, mapped `8080:5000`.
- The container image is tagged **`cloudnotes-api:0.1.0`**.

## Local-only setup

You need locally installed: `git`, `terraform` (>= 1.5), `docker` with
Compose v2, and `curl`. No accounts, no `docker login`, no `terraform
login`, no cloud credentials of any kind.

Copy the env template (never commit the real `.env`):

```bash
cp .env.example .env
```

## Three planted issues (this is the assessment)

This repository has **exactly three intentional issues**, one in each
area below. Finding and fixing them *is* the assessment — this README
will not tell you the exact fix, only where to look.

1. **Terraform/HCL issue** — somewhere in `terraform/`, a value is
   used that was never declared as an input variable. It breaks
   `terraform validate` / `terraform plan`. Compare `variables.tf`
   against how the module is called in `main.tf` and what `outputs.tf`
   references.
2. **Docker/container issue** — the `Dockerfile` tries to copy a
   requirements file that does not match what actually exists in
   `app/`. `docker build` will fail until the path is corrected.
3. **Security issue** — `compose.yaml` currently commits something
   that looks like a real, hardcoded credential directly in tracked
   config. It needs to move to a runtime secret sourced from `.env`
   (see `.env.example`) instead of living in the file itself.

Do not delete or bypass any validation step to "fix" these issues —
the underlying cause must be corrected.

## Task 1 — Terraform (local/mock-safe, no cloud provider)

```bash
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out=tfplan
```

All four commands must succeed once the Terraform issue is fixed.
State is local only (`terraform.tfstate`, ignored by git) — the
comments in `terraform/main.tf` explain why a real remote backend
would matter for a team, and why this exercise intentionally doesn't
use one.

## Task 2 — Docker build and Compose

```bash
docker build -t cloudnotes-api:0.1.0 .
docker compose up -d --build
curl http://localhost:8080/health
docker compose ps
```

`curl` must return HTTP 200 with `"status":"ok"` once the Docker issue
is fixed. The `registry` service (`registry:2`) is a local,
login-free registry included so you can practice a push/pull artifact
flow entirely on your machine — it is optional to use.

## Task 3 — Security check

```bash
./security/check.sh
```

Must exit `0` once the security issue is fixed. It checks that `.env`
is not tracked by git, that no obvious hardcoded token/secret/private
key patterns exist in tracked files, and that the Dockerfile doesn't
bake in a secret. If [Trivy](https://aquasecurity.github.io/trivy/) is
installed locally, you may additionally run:

```bash
trivy image cloudnotes-api:0.1.0
```

Trivy is optional — it's fine if it isn't installed; just note that in
`release-notes.md`.

## Cleanup

```bash
docker compose down
rm -f terraform/tfplan
```

## Submitting

Fill in `release-notes.md` with your evidence for all three tasks,
export it (or your notes + screenshots) as a **PDF**, and submit it
along with your forked repository URL, as described in the assessment
brief given to you separately.
