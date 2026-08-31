# CloudNotes Release Notes

Fill in every section below as you complete the assessment. Replace
each `_TODO_` with your own findings and evidence (paste command
output, not just descriptions).

## 1. Issue diagnosis

For each of the three planted issues, describe: original error
message, root cause, and the fix you applied.

- **Terraform/HCL issue:** _TODO_
- **Docker/container issue:** _TODO_
- **Security issue:** _TODO_

## 2. Terraform plan evidence

Paste the output (or a summary) of:

```bash
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out=tfplan
```

_TODO_

## 3. Docker artifact

Image tag, build command used, and image size:

```bash
docker build -t cloudnotes-api:0.1.0 .
docker image inspect cloudnotes-api:0.1.0 --format '{{.RepoTags}} {{.Size}}'
```

_TODO_

## 4. Compose health

```bash
docker compose up -d --build
curl http://localhost:8080/health
docker compose ps
```

_TODO_ (paste the health JSON response and `compose ps` output)

## 5. Security checks

```bash
./security/check.sh
```

_TODO_ (paste output; note whether Trivy was available/run)

## 6. State / backend note

Explain why Terraform state should be isolated from source code, and
why a remote backend is useful for team collaboration even though this
exercise intentionally uses a local backend.

_TODO_

## 7. Architecture

Briefly describe the pieces: Flask API service, Docker network
(Compose), local registry/artifact flow, and the Terraform-modeled
network/service/registry-namespace.

_TODO_

## 8. Remaining risk

What would you still need to do before this could run on a real cloud
provider (e.g. real backend, real registry auth, secret manager)?

_TODO_

## 9. Rebuild command

Exact command(s) to rebuild the tagged image from a clean checkout:

```bash
_TODO_
```

## 10. Final release decision

State clearly: **Go** or **No-Go**, and why, based on the evidence
above.

_TODO_
