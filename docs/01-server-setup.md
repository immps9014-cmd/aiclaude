# 01. 서버(포털) 셋업 가이드

대상 서버: **103.55.191.157 / Rocky Linux 8.10 / 1 vCPU / 1.7GB RAM**

이 서버는 **정적 포털만** 호스팅하므로 현재 사양으로 충분합니다.
(라이브 앱·빌드는 서버에서 돌리지 않습니다.)

## 0. 사전 보안 조치 (필수)

이전에 root 비밀번호가 노출된 적이 있다면 **반드시 먼저 변경**하세요.

```bash
# 1) root 비밀번호 변경
passwd

# 2) SSH 키 인증 전환 (내 PC에서 공개키 등록)
#    내 PC:  ssh-copy-id root@103.55.191.157
# 3) 비밀번호 로그인/ root 직접 로그인 비활성화 권장
#    /etc/ssh/sshd_config 에서:
#      PermitRootLogin prohibit-password
#      PasswordAuthentication no
systemctl reload sshd
```

## 1. DNS 설정

도메인 관리 콘솔에서 A 레코드를 추가합니다.

```
edu.aiclaude.kr.   A   103.55.191.157
```

전파 확인:

```bash
dig +short edu.aiclaude.kr      # 103.55.191.157 가 나오면 OK
```

## 2. 자동 셋업 스크립트 실행

저장소를 서버에 clone 한 뒤:

```bash
git clone https://github.com/immps9014-cmd/aiclaude.git
cd aiclaude
chmod +x scripts/server-setup.sh
sudo ./scripts/server-setup.sh
```

스크립트가 수행하는 작업:

1. 시스템 업데이트 + `firewalld`, `fail2ban` (기본 보안)
2. **Nginx** 설치·기동
3. 웹 루트 `/var/www/edu` 생성 (SELinux 컨텍스트 포함)
4. `edu.aiclaude.kr` 가상호스트 설정
5. **Let's Encrypt SSL** 자동 발급 + HTTPS 리다이렉트

> SSL 발급은 DNS A 레코드가 전파된 후에만 성공합니다.
> 실패해도 HTTP로는 동작하며, 나중에 `certbot --nginx -d edu.aiclaude.kr` 로 재시도 가능합니다.

## 3. 포털 배포

```bash
# 서버에서 직접 (저장소를 서버에 둔 경우)
sudo ./scripts/deploy-portal.sh

# 또는 내 PC에서 원격 배포 (rsync)
REMOTE=root@103.55.191.157 ./scripts/deploy-portal.sh
```

배포 후 브라우저에서 `https://edu.aiclaude.kr` 접속 확인.

## 4. 콘텐츠 업데이트 흐름

포털 내용을 바꿀 때:

1. 로컬에서 `portal/` 의 HTML 수정
2. Git commit & push
3. 서버에서 `git pull` 후 `deploy-portal.sh` 재실행 (또는 원격 rsync)

## 5. 리소스 메모

- 정적 포털이라 메모리 점유는 수십 MB 수준 → 현재 1.7GB로 여유
- 단, 서버에서 **무거운 빌드/Node 앱을 돌리지 마세요** (메모리 부족 위험)
- 모니터링: `free -h`, `systemctl status nginx`

## 문제 해결

| 증상 | 확인 |
|------|------|
| 502/접속 불가 | `systemctl status nginx`, `nginx -t` |
| 403 Forbidden | 웹 루트 권한·SELinux: `restorecon -Rv /var/www/edu` |
| SSL 실패 | DNS 전파(`dig`), 80포트 외부 접근, certbot 재시도 |
| 방화벽 차단 | `firewall-cmd --list-services` (http/https 포함 확인) |
