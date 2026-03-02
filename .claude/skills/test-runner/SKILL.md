---
name: test-runner
description: 測試工作流程自動化 — 偵測測試框架並執行測試
user-invocable: false
---

# test-runner — 測試工作流程（自動觸發）

此 Skill 不由使用者直接調用，而是當 Claude 偵測到與測試相關的語境時（如「跑測試」、「執行測試」、「run tests」）自動啟用。

## 當前專案資訊

以下是 `package.json` 的內容（若存在），用於偵測測試框架設定：

```
!`cat package.json 2>/dev/null || echo '{"scripts":{},"devDependencies":{}}'`
```

## 測試框架偵測規則

依照以下優先順序偵測專案使用的測試框架：

| 優先序 | 框架 | 偵測條件 | 執行指令 |
|--------|------|---------|---------|
| 1 | npm scripts | `package.json` 中有 `scripts.test` | `npm test` |
| 2 | pytest | 存在 `pyproject.toml` 或 `pytest.ini` | `pytest -v` |
| 3 | cargo | 存在 `Cargo.toml` | `cargo test` |
| 4 | maven | 存在 `pom.xml` | `mvn test` |
| 5 | go | 存在 `go.mod` | `go test ./...` |

## 執行流程

1. **偵測框架**：根據上表偵測專案使用的測試框架
2. **執行測試**：使用對應的指令執行測試
3. **分析結果**：解析測試輸出，摘要通過/失敗的測試
4. **報告**：
   - 若全部通過：簡要報告測試數量與執行時間
   - 若有失敗：列出失敗的測試名稱、錯誤訊息，並建議修復方向

## 輸出格式

### 全部通過時
```
✅ 測試全部通過（X 個測試，耗時 Y 秒）
```

### 有失敗時
```
❌ 測試失敗（X 通過 / Y 失敗 / Z 總計）

失敗的測試：
1. <測試名稱> — <錯誤摘要>
2. <測試名稱> — <錯誤摘要>

建議修復方向：
- <具體建議>
```

## 注意事項

- 此 Skill 為 `user-invocable: false`，不會出現在 `/` 選單中
- 使用 `` !`command` `` 語法在載入時動態注入 `package.json` 內容
- 若專案中無法偵測到任何測試框架，會提示使用者設定測試環境
