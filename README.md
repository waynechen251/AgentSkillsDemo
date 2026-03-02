# AgentSkillsDemo

Claude Code Agent Skills 系統教學示範專案。

## 簡介

本專案透過六個實用的 Skill 組成完整的開發工作流程管線，示範 Claude Code Skills 系統的各項特性。所有 Skills 定義在 `.claude/skills/` 目錄下，透過 Git 與團隊共享，同時支援 Claude Code CLI 與 VSCode 擴充套件。

## 工作流程管線

```
/scaffold → /code-review → (auto)test-runner → /commit → /pr-prepare → /doc-gen
```

| Skill | 觸發方式 | 用途 | 展示特性 |
|-------|----------|------|----------|
| `/scaffold` | `/scaffold <type> [name]` | 建立專案腳手架 | 位置參數、disable-model-invocation |
| `/code-review` | `/code-review [path]` | 程式碼審查（唯讀） | fork 子代理、Explore agent、allowed-tools |
| `test-runner` | Claude 自動觸發 | 偵測並執行測試 | user-invocable: false、動態注入 |
| `/commit` | `/commit [scope]` | 規範化 Git 提交 | 環境變數注入、Conventional Commits |
| `/pr-prepare` | `/pr-prepare [base]` | 產生 PR 描述 | 動態注入、支援檔案、fork |
| `/doc-gen` | `/doc-gen <path> [type]` | 生成技術文件 | fork 子代理、Explore agent、支援檔案 |

## 快速開始

### 前置需求

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) 已安裝
- Git Bash（Windows 使用者需要，MINGW64 環境）
- 選用：`jq`（Hook 腳本用於解析 JSON）

### 使用步驟

1. **複製專案**
   ```bash
   git clone <repository-url>
   cd AgentSkillsDemo
   ```

2. **啟動 Claude Code**
   ```bash
   claude
   ```

3. **查看可用 Skills**
   輸入 `/` 即可看到 5 個使用者可觸發的 Skill。

4. **試用腳手架**
   ```
   /scaffold node-api my-service
   ```

5. **執行程式碼審查**
   ```
   /code-review src/
   ```

## 專案結構

```
AgentSkillsDemo/
├── .claude/
│   ├── settings.json              # 團隊共用設定（權限 + Hook）
│   ├── hooks/
│   │   └── lint-on-write.sh       # 寫入後檢查 console.log 殘留
│   └── skills/
│       ├── scaffold/
│       │   └── SKILL.md           # 專案腳手架產生器
│       ├── code-review/
│       │   └── SKILL.md           # 程式碼審查助手
│       ├── test-runner/
│       │   └── SKILL.md           # 測試工作流程（自動觸發）
│       ├── commit/
│       │   └── SKILL.md           # 規範化 Git 提交
│       ├── pr-prepare/
│       │   ├── SKILL.md           # PR 準備助手
│       │   └── template.md        # PR 描述模板
│       └── doc-gen/
│           ├── SKILL.md           # 技術文件生成器
│           └── examples/
│               └── sample-output.md  # API 文件範例輸出
├── .vscode/
│   └── settings.json              # VSCode 編輯器整合設定
├── .gitignore                     # Git 排除規則
├── CLAUDE.md                      # 專案指引
└── README.md                      # 本文件
```

## Skills 特性覆蓋矩陣

本專案刻意讓每個 Skill 展示不同的 Skills 系統特性：

| 特性 | scaffold | code-review | test-runner | commit | pr-prepare | doc-gen |
|------|:--------:|:-----------:|:-----------:|:------:|:----------:|:-------:|
| `$0`, `$1` 位置參數 | ✅ | | | | | ✅ |
| `$ARGUMENTS` 完整參數 | | | | ✅ | | |
| `argument-hint` | ✅ | ✅ | | ✅ | ✅ | ✅ |
| `disable-model-invocation` | ✅ | | | ✅ | ✅ | |
| `user-invocable: false` | | | ✅ | | | |
| `context: fork` | | ✅ | | | ✅ | ✅ |
| `agent: Explore` | | ✅ | | | | ✅ |
| `allowed-tools` 限制 | | ✅ | | | ✅ | ✅ |
| `` !`command` `` 動態注入 | | | ✅ | | ✅ | |
| `${CLAUDE_SESSION_ID}` | | | | ✅ | | |
| 支援檔案 | | | | | ✅ | ✅ |

## 設定檔說明

### `.claude/settings.json` — 權限與 Hook

三層權限控制：

| 層級 | 說明 | 涵蓋工具 |
|------|------|---------|
| **allow** | 自動允許 | Read、Glob、Grep、git status/log/diff、npm lint/test |
| **ask** | 每次詢問 | Write、Edit、git add/commit/push、gh pr create |
| **deny** | 永遠拒絕 | rm -rf、git reset --hard、git push --force、讀取 .env |

### PostToolUse Hook: `lint-on-write.sh`

- **觸發**：Claude 使用 `Write` 或 `Edit` 工具後
- **行為**：檢查 JS/TS 檔案中的 `console.log` 殘留
- **輸出**：透過 `systemMessage` 顯示警告（非阻擋）
- **依賴**：`jq`（若未安裝會靜默跳過）

## 教學重點

### 1. Skill 定義結構

每個 Skill 是一個 `SKILL.md` 檔案，使用 YAML frontmatter 定義元資料：

```yaml
---
name: skill-name
description: Skill 描述
user-invocable: true
argument-hint: "<必填> [選填]"
context: fork          # 選填：在子代理中執行
agent: Explore         # 選填：使用特定代理類型
allowed-tools:         # 選填：限制可用工具
  - Read
  - Grep
disable-model-invocation: true  # 選填：僅做指定動作
---
```

### 2. 支援檔案

Skill 目錄下除了 `SKILL.md`，其他檔案（如 `template.md`、`examples/`）會作為支援檔案載入，提供額外的上下文。

### 3. 動態注入

使用 `` !`command` `` 語法可在 Skill 載入時執行 shell 指令，將輸出注入到 Skill 內容中。適合注入當前環境狀態。

### 4. Hook 系統

Hook 透過 JSON stdin/stdout 協定與 Claude Code 溝通：
- **輸入**：工具名稱與參數（JSON via stdin）
- **輸出**：`systemMessage`（警告）或 `stopExecution`（阻擋）
- **exit code**：0 = 成功，非 0 = Hook 執行失敗

## 常見問題

### Q: 為什麼 `/` 選單只看到 5 個 Skill？

`test-runner` 設定了 `user-invocable: false`，因此不會出現在使用者選單中。它會在 Claude 偵測到測試相關語境時自動啟用。

### Q: Hook 在 Windows 上能運作嗎？

需要 Git Bash（MINGW64 環境）。如果你使用 Git for Windows，通常已具備此環境。

### Q: 沒有安裝 `jq` 會怎樣？

`lint-on-write.sh` 會在偵測到 `jq` 不存在時靜默跳過，不會產生錯誤。

## 授權

MIT License
