#!/usr/bin/env bash
#
# edu.aiclaude.kr 포털 서버 초기 셋업 스크립트
# 대상 OS: Rocky Linux 8.x (현재 서버: 1 vCPU / 1.7GB RAM — 정적 포털 운영에 충분)
#
# 하는 일:
#   1) 시스템 업데이트 + 기본 보안 (firewalld, fail2ban)
#   2) Nginx 설치 및 기동
#   3) 포털 디렉토리(/var/www/edu) 생성
#   4) Nginx 가상호스트 설정 (edu.aiclaude.kr)
#   5) Let's Encrypt SSL 발급 (certbot)
#
# 사용법 (서버에서 root 또는 sudo로):
#   chmod +x server-setup.sh
#   ./server-setup.sh
#
set -euo pipefail

DOMAIN="edu.aiclaude.kr"
WEBROOT="/var/www/edu"
ADMIN_EMAIL="immps9014@gmail.com"   # Let's Encrypt 알림용

echo "==> [1/5] 시스템 업데이트 및 기본 보안 패키지 설치"
dnf -y update
dnf -y install epel-release
dnf -y install nginx firewalld fail2ban policycoreutils-python-utils

echo "==> 방화벽 설정 (HTTP/HTTPS/SSH 만 허용)"
systemctl enable --now firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

echo "==> fail2ban 기동 (SSH 무차별 대입 차단)"
systemctl enable --now fail2ban

echo "==> [2/5] Nginx 기동"
systemctl enable --now nginx

echo "==> [3/5] 포털 디렉토리 생성: ${WEBROOT}"
mkdir -p "${WEBROOT}"
chown -R nginx:nginx "${WEBROOT}"
# SELinux 컨텍스트 (Rocky 기본 enforcing 대비)
if command -v semanage >/dev/null 2>&1; then
  semanage fcontext -a -t httpd_sys_content_t "${WEBROOT}(/.*)?" || true
  restorecon -Rv "${WEBROOT}" || true
fi

echo "==> [4/5] Nginx 가상호스트 설정"
cat > /etc/nginx/conf.d/edu.conf <<NGINX
server {
    listen 80;
    server_name ${DOMAIN};
    root ${WEBROOT};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # 정적 자산 캐시
    location ~* \.(css|js|png|jpg|jpeg|svg|woff2?)\$ {
        expires 7d;
        add_header Cache-Control "public";
    }
}
NGINX

nginx -t
systemctl reload nginx

echo "==> [5/5] Let's Encrypt SSL 발급"
echo "    (사전 조건: ${DOMAIN} 의 DNS A 레코드가 이 서버 IP를 가리켜야 함)"
dnf -y install certbot python3-certbot-nginx
certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos -m "${ADMIN_EMAIL}" --redirect || {
  echo "!! SSL 발급 실패 — DNS 전파 또는 80포트 접근을 확인하세요. HTTP로는 이미 동작합니다."
}

echo ""
echo "============================================================"
echo " 완료! 포털 콘텐츠를 ${WEBROOT} 에 배포하세요."
echo "   배포 스크립트: scripts/deploy-portal.sh 참고"
echo " 확인: https://${DOMAIN}"
echo "============================================================"
