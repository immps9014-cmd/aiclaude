# edu.aiclaude.kr — Claude Code 교육 포털 & 운영 가이드

15명의 교육생이 **각자의 PC에서 Claude Code로 프로젝트를 개발**하고,
**GitHub로 관리**하며, 결과물을 **포털에 공유**하는 교육 과정의 운영 자료입니다.

## 운영 모델 (서버 부담 최소화)

```
edu.aiclaude.kr (103.55.191.157, 1코어/1.7GB)
        │  ← 정적 포털만 호스팅 (부하 거의 없음)
        ▼
  교육 포털 (안내 · 시작 가이드 · 진행 현황)
        │ 링크로 연결
        ▼
  학생 PC × 15  ──(개발: Claude Code)──▶  GitHub Org  ──(배포)──▶  Vercel / GitHub Pages
```

- **서버**: 교육 포털(정적 HTML/CSS)만 담당 → 현재 소형 서버로 충분
- **개발**: 빌드·실행 등 모든 부하는 학생 PC에서 발생
- **관리**: GitHub Organization으로 15명 프로젝트 통합 관리
- **배포**: 학생 결과물은 무료 호스팅 → 포털에 링크만 모음

## 디렉토리 구성

```
portal/                 서버에 올릴 교육 포털 (순수 HTML/CSS, 빌드 불필요)
  index.html              메인
  onboarding.html         학생용 시작 가이드
  progress.html           진행 현황판 (강사가 학생 정보 업데이트)
  assets/style.css
docs/                   운영 가이드 문서
  01-server-setup.md      서버(포털) 셋업
  02-student-onboarding.md 학생 PC 환경 구축 (Windows/Mac)
  03-github-guide.md      GitHub Organization 구성·운영
  04-deployment.md        학생 결과물 배포 방법
scripts/
  server-setup.sh         Rocky Linux 8 서버 셋업 자동화 (Nginx + SSL)
  deploy-portal.sh        포털 콘텐츠 배포 (로컬/원격)
```

## 빠른 시작 (강사용)

1. **서버 준비** — `docs/01-server-setup.md` → `scripts/server-setup.sh` 실행
2. **포털 배포** — `scripts/deploy-portal.sh` 로 `portal/` 배포
3. **GitHub Org 생성** — `docs/03-github-guide.md` 따라 Org + 학생 repo 15개
4. **Claude Team 초대** — claude.ai Team에 학생 15명 Google 계정 초대
5. **학생 온보딩** — 학생들에게 포털 `시작 가이드`(onboarding.html) 안내
6. **진행 관리** — `progress.html` 에 학생 정보·배포 링크 업데이트

## 체크리스트

- [ ] 서버 기본 보안 (root 비밀번호 변경, SSH 키 인증, 방화벽)
- [ ] DNS: `edu.aiclaude.kr A 103.55.191.157`
- [ ] Nginx + Let's Encrypt SSL
- [ ] 포털 배포 및 접속 확인
- [ ] GitHub Organization + 학생 repo 15개
- [ ] Claude Team 좌석 15개 + 학생 초대
- [ ] 학생 온보딩 (파일럿 1명 → 전체)

자세한 내용은 `docs/` 의 각 문서를 참고하세요.
