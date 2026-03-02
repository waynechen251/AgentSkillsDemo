---
name: commit
description: 規範化 Git 提交 — 遵循 Conventional Commits 產生標準化提交訊息
user-invocable: true
argument-hint: "[scope]  例如: api, ui, docs, config"
disable-model-invocation: true
---

# /commit — 規範化 Git 提交

## 參數

- `$ARGUMENTS`（選填）：提交的 scope，例如 `api`、`ui`、`docs`、`config`

## 環境資訊

- **Session ID**：`${CLAUDE_SESSION_ID}`

## Conventional Commits 規範

提交訊息格式：
```
<type>(<scope>): <subject>

<body>

Session: <session-id>
Co-Authored-By: Claude <noreply@anthropic.com>
```

### Type 列表

| Type | 用途 | 範例 |
|------|------|------|
| `feat` | 新功能 | `feat(api): 新增使用者認證端點` |
| `fix` | 修復錯誤 | `fix(ui): 修正登入表單驗證邏輯` |
| `docs` | 文件變更 | `docs: 更新 API 使用說明` |
| `style` | 格式調整（不影響邏輯） | `style: 統一縮排格式` |
| `refactor` | 重構（無功能變更） | `refactor(core): 簡化錯誤處理流程` |
| `test` | 測試相關 | `test(api): 補充認證模組單元測試` |
| `chore` | 雜務（建置、工具） | `chore: 更新依賴版本` |
| `ci` | CI/CD 變更 | `ci: 新增自動化測試工作流程` |

### 規則

- **type/scope**：使用英文
- **subject**：使用繁體中文，不超過 50 字元，不加句號
- **body**：使用繁體中文，說明「為什麼」而非「做了什麼」
- **footer**：包含 Session ID 與 Co-Authored-By

## 執行流程

1. **檢查暫存區**：執行 `git status` 確認有已暫存的變更
2. **分析變更**：執行 `git diff --cached` 瞭解變更內容
3. **判斷 type**：根據變更內容自動判斷最適合的 type
4. **設定 scope**：使用 `$ARGUMENTS` 作為 scope，若未提供則根據變更路徑推斷
5. **撰寫 subject**：用繁體中文簡述變更目的
6. **撰寫 body**：說明變更的原因與影響
7. **組合訊息**：按照格式組合完整的提交訊息
8. **確認並提交**：顯示完整訊息讓使用者確認後執行 `git commit`

## 範例

假設使用者執行 `/commit api`，且暫存區有新增的 API 路由：

```
feat(api): 新增使用者認證端點

實作 JWT 認證機制，支援登入、登出與 token 更新功能。
新增對應的中介層以保護需要認證的路由。

Session: ${CLAUDE_SESSION_ID}
Co-Authored-By: Claude <noreply@anthropic.com>
```

## 注意事項

- 若暫存區為空，提示使用者先執行 `git add`
- 若變更過多（超過 10 個檔案），建議分批提交
- Session ID 透過 `${CLAUDE_SESSION_ID}` 環境變數自動注入，用於追蹤提交來源
