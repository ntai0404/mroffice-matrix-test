#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="$ROOT_DIR/reports"
mkdir -p "$REPORT_DIR"
LOG_FILE="$REPORT_DIR/MROFFICE_BUILD_TEST_20261127.txt"
WORK_DIR="${MROFFICE_WORK_DIR:-/tmp/MROffice-test-20261127}"

exec > >(tee "$LOG_FILE") 2>&1

echo "=================================================================="
echo "MROFFICE BUILD & TEST REPORT - $(date -Is)"
echo "Host: $(hostname) | User: $(whoami)"
echo "=================================================================="

echo ""
echo "=== [CHECKLIST 1] Environment Survey & Clone XinaTian/MROffice ==="
uname -a
lscpu | grep -E "Model name|CPU\(s\):" || true
free -h || true
node -v
npm -v
git --version

rm -rf "$WORK_DIR"
git clone --depth 1 https://github.com/XinaTian/MROffice.git "$WORK_DIR"
cd "$WORK_DIR"
echo "Cloned commit HEAD: $(git rev-parse HEAD) ($(git rev-parse --short HEAD))"
git log -n 1 --oneline

echo ""
echo "=== [CHECKLIST 2] Install Dependencies, Third-Party Notices & Office Fonts ==="
npm ci --no-audit --no-fund
node scripts/third-party-notices.mjs --check
npm run fonts

echo ""
echo "=== [CHECKLIST 3] Build Web Editors & Playground ==="
NODE_OPTIONS="--max-old-space-size=8192" npm run build
du -sh apps/playground/dist || true
ls -la apps/playground/dist || true

echo ""
echo "=== [CHECKLIST 4A] Web Editors Smoke Test (Word/Excel/PowerPoint/PDF/Code) ==="
npm install --no-save --no-audit --no-fund playwright@1.58.2
npx playwright install chromium
node scripts/smoke.mjs

echo ""
echo "=== [CHECKLIST 4B] Desktop Shell Typecheck & Unit Tests ==="
(
  cd apps/desktop
  ELECTRON_SKIP_BINARY_DOWNLOAD=1 npm ci --no-audit --no-fund
  npm test
)

echo ""
echo "=== [CHECKLIST 5] Web Playground Preview Server Verification ==="
npx vite preview --port 4173 --host 127.0.0.1 --dir apps/playground/dist >/tmp/mroffice_preview.log 2>&1 &
PREVIEW_PID=$!
trap 'kill $PREVIEW_PID 2>/dev/null || true' EXIT
sleep 3
curl -i -sS --max-time 10 http://127.0.0.1:4173/ | head -n 20
kill $PREVIEW_PID 2>/dev/null || true

echo ""
echo "=================================================================="
echo "ALL 5 CHECKLISTS COMPLETED: PASS - $(date -Is)"
echo "Report saved to: $LOG_FILE"
echo "=================================================================="
