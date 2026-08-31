#!/usr/bin/env bash
# CloudNotes local security check.
#
# This script does NOT need any cloud account, login, or real
# credential. It only inspects files already on disk / tracked by
# git. It must exit 0 once all three planted issues are fixed and
# exit non-zero (with a clear message) otherwise.

set -u
fail=0

echo "== CloudNotes security check =="

# 1. .env must never be tracked by git (only .env.example may be).
if git ls-files --error-unmatch .env >/dev/null 2>&1; then
  echo "[FAIL] .env is tracked by git. Remove it and keep it in .gitignore."
  fail=1
else
  echo "[OK] .env is not tracked by git."
fi

# 2. No obvious hardcoded token / secret / private-key patterns in
#    tracked source files (compose.yaml, Dockerfile, app/, terraform/).
#    .env.example is allowed to contain the fake placeholder value.
PATTERN='sk-live-|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|API_TOKEN[[:space:]]*[:=][[:space:]]*"?[A-Za-z0-9_-]{12,}'

hits=$(git ls-files \
  | grep -v -E '^\.env\.example$|^security/check\.sh$' \
  | xargs grep -nE "$PATTERN" 2>/dev/null || true)

if [ -n "$hits" ]; then
  echo "[FAIL] Possible hardcoded secret pattern found in tracked files:"
  echo "$hits"
  fail=1
else
  echo "[OK] No obvious hardcoded secret patterns in tracked files."
fi

# 3. Dockerfile must not contain a secret literal (e.g. ENV/ARG with
#    a hardcoded token/password value).
if grep -nE '(ENV|ARG)[[:space:]]+[A-Z_]*(TOKEN|SECRET|PASSWORD)[[:space:]]*=' Dockerfile >/dev/null 2>&1; then
  echo "[FAIL] Dockerfile appears to hardcode a secret via ENV/ARG."
  fail=1
else
  echo "[OK] Dockerfile does not hardcode a secret."
fi

if [ "$fail" -eq 0 ]; then
  echo "== All security checks passed =="
  exit 0
else
  echo "== Security checks FAILED =="
  exit 1
fi
