---
name: doc-gen
description: 技術文件生成器 — 分析程式碼並產生結構化技術文件
user-invocable: true
argument-hint: "<path> [type]  類型: overview | api | architecture | changelog"
context: fork
agent: Explore
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git log*)
  - Bash(git diff*)
  - Bash(git tag*)
---

# /doc-gen — 技術文件生成器

## 參數

- `$0`（必填）：要分析的檔案或目錄路徑
- `$1`（選填）：文件類型，可選值為 `overview`、`api`、`architecture`、`changelog`，預設為 `overview`

## 執行環境

此 Skill 在 **fork 子代理** 中以 **唯讀模式** 執行（Explore agent），先分析程式碼再產生文件。

## 文件類型說明

### overview — 專案總覽

產生專案的整體介紹文件，包含：
- 專案目的與功能描述
- 技術棧與主要依賴
- 目錄結構說明
- 快速開始指引
- 開發環境設定

### api — API 參考文件

分析程式碼中的 API 端點或公開介面，產生：
- 端點列表與 HTTP 方法
- 請求/回應格式（含範例）
- 參數說明與型別
- 錯誤碼與錯誤格式
- 認證需求

參考 `examples/sample-output.md` 的格式範例。

### architecture — 架構文件

分析專案的架構設計，產生：
- 系統架構圖（ASCII）
- 模組職責與邊界
- 資料流向
- 關鍵設計決策
- 依賴關係圖

### changelog — 變更日誌

根據 Git 歷史產生結構化的變更日誌：
- 依版本或時間區間分組
- 按 Conventional Commits type 分類
- 標注重大變更（Breaking Changes）
- 關聯 Issue 與 PR 編號

## 輸出格式

所有文件使用 Markdown 格式，遵循以下規範：
- 標題使用繁體中文
- 程式碼範例保留原始語言
- 表格用於結構化資訊
- 適當使用 Mermaid 或 ASCII 圖表

## 輸出範例

### overview 類型

```markdown
# <專案名稱>

## 簡介
<2-3 句話描述專案用途>

## 技術棧
| 類別 | 技術 |
|------|------|
| 語言 | TypeScript |
| 框架 | Express.js |
| 資料庫 | PostgreSQL |

## 目錄結構
<樹狀結構說明>

## 快速開始
<步驟化的啟動指引>
```

## 注意事項

- 此 Skill 為唯讀操作，分析完成後將文件內容輸出供使用者複製或儲存
- 大型專案建議指定特定目錄以縮小分析範圍
- 文件內容使用繁體中文撰寫
- `examples/sample-output.md` 提供 API 文件的完整格式範例
