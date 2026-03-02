# AgentSkillsDemo — 專案指引

## 專案概述

這是一個 Claude Code Agent Skills 系統的教學示範專案，用於讓開發團隊學習如何組織 Skills、Hooks 與設定檔來建立共用的開發工作流程。

## 語言規範

- **所有文件與註解**：使用繁體中文
- **程式碼變數與函式名稱**：使用英文
- **Git commit type/scope**：使用英文（如 `feat(api):`）
- **Git commit subject**：使用繁體中文描述

## 工作流程管線

本專案定義了六個 Skill，組成完整的開發工作流程：

```
/scaffold → /code-review → (auto)test-runner → /commit → /pr-prepare → /doc-gen
```

| Skill | 觸發方式 | 用途 |
|-------|----------|------|
| `/scaffold` | 手動 | 建立專案腳手架 |
| `/code-review` | 手動 | 程式碼審查（唯讀） |
| `test-runner` | 自動 | 偵測並執行測試 |
| `/commit` | 手動 | 規範化 Git 提交 |
| `/pr-prepare` | 手動 | 產生 PR 描述 |
| `/doc-gen` | 手動 | 生成技術文件 |

## 程式碼風格

- JavaScript/TypeScript：使用 ESM 模組、2 空格縮排
- Python：遵循 PEP 8、使用 type hints
- 所有檔案結尾保留一個換行符號

## 重要注意事項

- 請勿在 JS/TS 檔案中留下 `console.log`，Hook 會自動偵測並警告
- 提交前請先執行 `/code-review` 確認程式碼品質
- PR 描述請使用 `/pr-prepare` 自動生成，確保格式一致
