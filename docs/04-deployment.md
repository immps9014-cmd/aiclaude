# 04. 학생 결과물 배포 가이드

학생 프로젝트는 **서버(edu.aiclaude.kr)에서 직접 실행하지 않습니다.**
무료 호스팅에 배포하고, 포털 **진행 현황** 페이지에 링크만 등록합니다.
(서버 부하 0 + 관리 단순)

## 배포처 선택

| 프로젝트 유형 | 추천 호스팅 | 비고 |
|--------------|------------|------|
| 정적 사이트 (HTML/CSS/JS, React·Vue 빌드 결과물) | **GitHub Pages**, Cloudflare Pages | 무료, repo와 연동 |
| 풀스택 / SSR (Next.js 등) | **Vercel**, Netlify | 무료 티어, Git 연동 자동배포 |
| 백엔드 API 포함 | Vercel / Render / Railway | 무료 한도 내 |

## A. GitHub Pages (정적 사이트)

1. repo Settings → Pages
2. Source: `main` 브랜치 / `/root` 또는 `/docs`
3. 빌드가 필요한 프레임워크는 GitHub Actions로 빌드 후 배포
4. 배포 URL: `https://aiclaude-edu.github.io/studentXX-project/`

빌드형(예: Vite/React)은 Actions 워크플로 예시:

```yaml
# .github/workflows/deploy.yml
name: Deploy to Pages
on:
  push: { branches: [main] }
permissions: { contents: read, pages: write, id-token: write }
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci && npm run build
      - uses: actions/upload-pages-artifact@v3
        with: { path: dist }   # 프레임워크 빌드 출력 폴더
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: github-pages
    steps:
      - uses: actions/deploy-pages@v4
```

## B. Vercel (풀스택 / SSR — 가장 쉬움)

1. https://vercel.com 에서 GitHub 계정으로 로그인
2. Import → 본인 repo 선택
3. 프레임워크 자동 감지 → Deploy
4. 이후 `git push` 할 때마다 **자동 재배포**
5. 배포 URL: `https://studentXX-project.vercel.app`

## C. 포털에 링크 등록

배포가 끝나면 학생이 강사에게 다음 정보를 전달:

- 프로젝트명
- 저장소 URL
- 배포 URL

강사는 `portal/progress.html` 의 해당 행을 업데이트하고 재배포:

```html
<tr>
  <td>01</td>
  <td>홍길동</td>
  <td>나의 할 일 앱</td>
  <td><a href="https://github.com/aiclaude-edu/student01-project">repo</a></td>
  <td><a href="https://student01-project.vercel.app">demo</a></td>
  <td><span class="badge ok">완료</span></td>
</tr>
```

그 후:

```bash
# 로컬에서 commit & push 후 서버에서
git pull && sudo ./scripts/deploy-portal.sh
```

## (선택) 서버 서브도메인 전시

정적 빌드 결과물을 굳이 서버에서 보여주고 싶다면, 학생 `dist/`를
`*.edu.aiclaude.kr` 서브도메인으로 서빙할 수 있습니다. 다만:

- **정적 결과물만** (Node 앱 직접 실행 금지 — 서버 메모리 부족)
- 와일드카드 DNS + 와일드카드 SSL 필요
- 관리 부담이 늘어나므로, 특별한 이유가 없으면 **무료 호스팅 + 링크** 방식을 권장합니다.
