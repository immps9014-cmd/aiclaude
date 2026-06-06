# 02. 학생 PC 환경 구축 가이드

각 교육생이 **본인 PC**에 개발 환경을 구축하는 절차입니다.
(웹 포털의 `onboarding.html` 과 동일 내용 — 강사 배포·인쇄용으로 정리)

## 준비물

- 본인 PC (Windows 10/11 또는 macOS)
- 본인 **Google 계정**
- 강사가 보낸 **Claude Team 초대 메일**
- 강사가 보낸 **GitHub Organization 초대**

---

## STEP 1. 기본 프로그램 설치

| 프로그램 | 다운로드 | 버전 |
|---------|----------|------|
| Node.js | https://nodejs.org | **LTS** (예: v20) |
| Git | https://git-scm.com | 최신 |
| VS Code | https://code.visualstudio.com | 최신 |

설치 확인 (터미널 / Windows는 PowerShell):

```bash
node -v
git --version
```

### Windows 사용자 — WSL2 권장

Claude Code와 개발 도구는 Linux 환경에서 가장 안정적입니다.
가능하면 WSL2(Ubuntu)를 설치하세요:

```powershell
# 관리자 PowerShell
wsl --install
# 재부팅 후 Ubuntu 터미널에서 Node.js, Git 설치
```

WSL2 설치가 어려우면 강사에게 문의하세요 (네이티브 Windows로도 진행 가능).

---

## STEP 2. Claude Code 설치

```bash
npm install -g @anthropic-ai/claude-code
claude --version   # 설치 확인
```

> `npm install` 시 권한 오류가 나면(맥/리눅스), `sudo` 없이 쓰도록 npm 전역 경로를
> 사용자 디렉토리로 바꾸는 방법을 강사에게 문의하세요.

---

## STEP 3. Claude Team 로그인 (본인 계정)

1. **Claude Team 초대 메일 수락** — 본인 Google 계정으로.
2. 프로젝트 폴더에서 `claude` 실행:

```bash
mkdir my-project
cd my-project
claude
```

3. 표시되는 **로그인 URL**을 브라우저에서 열고 **본인 계정으로 로그인**.
4. 완료되면 바로 Claude Code 사용 가능.

> 인증 정보는 본인 PC(`~/.claude`)에만 저장됩니다. 계정·토큰을 공유하지 마세요.

---

## STEP 4. GitHub 저장소 연결

1. **GitHub Organization 초대 수락**.
2. 본인 저장소 clone (저장소 이름은 강사 안내):

```bash
git clone https://github.com/aiclaude-edu/studentXX-project.git
cd studentXX-project
```

3. **매일 push** (자동 백업 + 진척 관리):

```bash
git add .
git commit -m "오늘 작업 내용"
git push
```

처음 push 시 GitHub 로그인이 필요합니다 (브라우저 인증 또는 Personal Access Token).

---

## STEP 5. 결과물 배포 → 포털 공유

완성한 프로젝트를 무료 호스팅에 배포하고, 링크를 강사에게 전달하면
포털 **진행 현황** 페이지에 등록됩니다. → 자세한 방법: `04-deployment.md`

---

## 자주 묻는 문제

| 증상 | 해결 |
|------|------|
| `claude` 명령 없음 | Node 설치 확인(`node -v`), npm 전역 설치 재시도 |
| 로그인 실패 | Claude Team 초대 수락 여부 확인 |
| `git push` 거부 | Org 초대 수락, 저장소 권한, GitHub 로그인 확인 |
| Windows에서 불안정 | WSL2(Ubuntu) 사용 권장 |

그래도 안 되면 **화면 캡처와 함께 담당 강사에게 문의**하세요.
