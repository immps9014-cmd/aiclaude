# 03. GitHub Organization 구성·운영 가이드

15명의 프로젝트를 체계적으로 관리하기 위해 **GitHub Organization**을 사용합니다.
(자동 백업 + 진척 관리 + 코드리뷰 + 평가를 한 번에)

## 1. Organization 생성

1. https://github.com/account/organizations/new 에서 무료 Organization 생성
2. 이름 예: `aiclaude-edu`
3. 강사 계정을 **Owner**로 설정

## 2. 학생 저장소 구성

학생별 저장소 1개씩, 일관된 네이밍을 권장합니다.

```
aiclaude-edu/student01-project
aiclaude-edu/student02-project
...
aiclaude-edu/student15-project
```

### 일괄 생성 (선택, GitHub CLI 사용)

강사 PC에서 `gh` CLI로 빠르게 만들 수 있습니다:

```bash
# gh CLI 로그인 후
ORG=aiclaude-edu
for i in $(seq -w 1 15); do
  gh repo create "$ORG/student$i-project" --private --add-readme \
    --description "교육생 student$i 프로젝트"
done
```

> 공개 여부: 결과물을 공개 전시할 거면 `--public`, 아니면 `--private`.

## 3. 학생 초대 & 권한

- 각 학생을 Organization **Member**로 초대 (본인 GitHub 계정)
- 권한 모델 2가지 중 선택:
  - **(A) 개인 저장소만 접근** — 학생은 본인 repo에만 write.
    팀(Team)을 학생별로 만들거나 저장소별 Collaborator로 추가.
  - **(B) 전체 read + 본인 write** — 서로의 코드를 참고하게 하려면.

간단하게는 저장소별 Collaborator 추가가 가장 직관적입니다:
저장소 → Settings → Collaborators and teams → 학생 계정 추가(Write).

## 4. 운영 규칙 (학생 안내)

- **매일 push** — 작업 종료 시 commit & push 습관화
- 커밋 메시지는 의미 있게 (예: "로그인 화면 추가")
- 민감 정보 금지 — API 키·비밀번호·`.env` 는 커밋하지 않기
  - 각 repo에 `.gitignore` 템플릿 배포 (node_modules, .env 등 포함)

### .gitignore 기본 템플릿

```gitignore
node_modules/
dist/
build/
.env
.env.local
.DS_Store
*.log
.claude/
```

## 5. 강사 모니터링

- Organization 메인에서 전체 저장소의 최근 활동(commit) 확인
- 각 repo의 Insights → 기여도/빈도로 진척 파악
- 필요 시 Pull Request 기반 코드리뷰 운영

## 6. 백업 관점

학생이 매일 push 하면 GitHub가 **1차 백업** 역할을 합니다.
서버에는 학생 코드가 없으므로(포털만 운영), 별도 코드 백업 부담이 없습니다.
