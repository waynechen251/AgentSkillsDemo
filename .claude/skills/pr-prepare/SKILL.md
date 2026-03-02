---
name: pr-prepare
description: PR 準備助手 — 分析分支差異並生成結構化的 Pull Request 描述
user-invocable: true
argument-hint: "[base]  目標分支，預設為 main"
context: fork
disable-model-invocation: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git *)
  - Bash(gh *)
---

# /pr-prepare — PR 準備助手

## 參數

- `$ARGUMENTS`（選填）：PR 的目標分支（base branch），預設為 `main`

## 當前分支狀態

以下資訊在 Skill 載入時自動注入：

**當前分支名稱：**
```
!`git branch --show-current 2>/dev/null || echo 'unknown'`
```

**與目標分支的提交差異：**
```
!`git log --oneline main..HEAD 2>/dev/null || echo '（無法取得差異，請確認 main 分支存在）'`
```

**變更檔案統計：**
```
!`git diff --stat main..HEAD 2>/dev/null || echo '（無法取得統計）'`
```

## PR 描述模板

使用 `template.md` 作為 PR 描述的基礎格式。

## 執行流程

1. **收集資訊**
   - 讀取當前分支名稱（已由 `` !`command` `` 注入）
   - 讀取提交記錄（已由 `` !`command` `` 注入）
   - 讀取變更統計（已由 `` !`command` `` 注入）
   - 讀取每個變更檔案的 diff 內容

2. **分析變更**
   - 將所有提交歸類（feat/fix/docs/refactor 等）
   - 識別主要變更與次要變更
   - 評估影響範圍

3. **生成 PR 內容**
   - **標題**：遵循格式 `<type>(<scope>): <繁體中文描述>`
   - **描述**：根據 `template.md` 模板填入分析結果
   - 自動勾選適用的變更類型
   - 列出具體的變更內容
   - 根據變更推斷測試計畫
   - 標註影響範圍與審查重點

4. **輸出結果**
   - 顯示建議的 PR 標題
   - 顯示完整的 PR 描述（Markdown 格式）
   - 提供可直接使用的 `gh pr create` 指令

## 輸出範例

```
## 建議的 PR 標題
feat(api): 新增使用者認證模組

## PR 描述
<根據 template.md 格式生成的完整描述>

## 建立 PR 指令
gh pr create --title "feat(api): 新增使用者認證模組" --body "<描述內容>"
```

## 注意事項

- 此 Skill 在 fork 子代理中執行，不會修改任何檔案
- 三個 `` !`command` `` 會在載入時自動執行，注入當前的 Git 狀態
- 若目標分支不存在，會提示使用者指定正確的分支名稱
- PR 描述使用繁體中文撰寫
