#!/usr/bin/env bash
#
# 포털 콘텐츠 배포 스크립트
# portal/ 디렉토리의 정적 파일을 웹 루트(/var/www/edu)로 복사합니다.
#
# 빌드 과정이 없는 순수 HTML/CSS이므로 복사만으로 배포가 끝납니다.
#
# 사용법 A) 서버에서 직접 (저장소를 서버에 clone 한 경우):
#   ./scripts/deploy-portal.sh
#
# 사용법 B) 내 PC에서 원격 배포 (rsync, SSH 키 인증 권장):
#   REMOTE=root@103.55.191.157 ./scripts/deploy-portal.sh
#
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)/portal/"
WEBROOT="/var/www/edu"
REMOTE="${REMOTE:-}"

if [[ -n "${REMOTE}" ]]; then
  echo "==> 원격 배포: ${SRC} -> ${REMOTE}:${WEBROOT}"
  rsync -avz --delete "${SRC}" "${REMOTE}:${WEBROOT}/"
  ssh "${REMOTE}" "chown -R nginx:nginx ${WEBROOT} && (command -v restorecon >/dev/null && restorecon -Rv ${WEBROOT} || true) && systemctl reload nginx"
else
  echo "==> 로컬 배포: ${SRC} -> ${WEBROOT}"
  mkdir -p "${WEBROOT}"
  rsync -av --delete "${SRC}" "${WEBROOT}/"
  chown -R nginx:nginx "${WEBROOT}"
  command -v restorecon >/dev/null && restorecon -Rv "${WEBROOT}" || true
  systemctl reload nginx
fi

echo "==> 배포 완료. https://edu.aiclaude.kr 에서 확인하세요."
