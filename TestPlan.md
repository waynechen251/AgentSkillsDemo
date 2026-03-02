情境測試計畫：Skills 完整工作流程實測
Context
本計畫設計一個「建立 Todo API 服務」的真實開發情境，讓使用者照步驟操作，依序測試所有 6 個 Skills 與 Hook，驗證整個工作流程管線是否正常運作。

測試情境概述
角色：你是一位後端工程師，任務是在現有的 AgentSkillsDemo 專案中，快速建立一個小型 Node.js API 服務，並走完完整的開發流程。

測試目標：

步驟	Skill / 功能	預期結果
1	/scaffold	產生 node-api 專案骨架
2	手動修改程式碼（含 console.log）	Hook 觸發並警告
3	/code-review	五維度分析並回報問題
4	test-runner（自動）	偵測並執行測試
5	/commit	產生符合規範的 Conventional Commit
6	/pr-prepare	生成 PR 描述草稿
7	/doc-gen	產生 API 技術文件
逐步操作說明
步驟一：建立專案骨架（測試 /scaffold）
在 Claude Code 對話框輸入：


/scaffold node-api todo-service
預期行為：

Claude 在當前目錄建立 todo-service/ 資料夾
自動產生 package.json、src/index.js、src/routes/health.js、tests/health.test.js 等檔案
不需要模型額外推論（disable-model-invocation 特性）
驗證：確認 todo-service/ 目錄已出現，且包含上述檔案

步驟二：加入功能程式碼（測試 Hook）
請 Claude 在 todo-service/src/routes/health.js 中加入一段含有 console.log 的程式碼，例如：


請在 todo-service/src/routes/health.js 的 handler 中加入一行 console.log('health check called')
預期行為：

Claude 使用 Edit 工具修改檔案
PostToolUse Hook（lint-on-write.sh）觸發
Claude 收到警告 systemMessage：「⚠️ 偵測到 console.log...」
Claude 應主動提醒你移除或說明理由
驗證：觀察 Claude 是否主動提到 console.log 警告

步驟三：程式碼審查（測試 /code-review）
在對話框輸入：


/code-review todo-service/src
預期行為：

啟動 Explore 子代理（fork 上下文）進行唯讀分析
回傳五維度評估：正確性、安全性、效能、可維護性、測試覆蓋
指出 console.log 問題與任何其他發現
不會修改任何檔案
驗證：確認回報中包含 console.log 相關警告，且評分有詳細說明

步驟四：執行測試（測試自動 test-runner）
請 Claude 執行測試：


請執行 todo-service 的測試
預期行為：

test-runner Skill 自動偵測 package.json 中的測試框架
執行 npm test 或對應指令
顯示測試結果摘要
驗證：確認測試能被自動偵測並執行（即使測試失敗也算成功觸發）

步驟五：提交變更（測試 /commit）
先確認有 staged 的變更（git add），然後輸入：


/commit feat
預期行為：

分析 staged 的 diff
自動產生符合 Conventional Commits 格式的訊息
commit subject 使用繁體中文
格式如：feat(todo-service): 新增健康檢查路由與基礎 API 骨架
驗證：git log --oneline -1 確認 commit 訊息格式正確

步驟六：準備 PR 描述（測試 /pr-prepare）
輸入：


/pr-prepare main
預期行為：

分析當前分支與 main 的差異（git diff main...HEAD）
使用 template.md 格式產生完整 PR 描述
包含：變更摘要、測試計畫、相關 Issue
驗證：確認輸出的 PR 描述包含結構化的 Markdown 段落

步驟七：生成技術文件（測試 /doc-gen）
輸入：


/doc-gen todo-service/src api
預期行為：

啟動 Explore 子代理分析 src/ 下的所有路由與函式
參考 examples/sample-output.md 的格式
產生 API 端點文件，包含路徑、方法、參數、回應範例
驗證：確認輸出文件包含至少一個端點的完整說明

注意事項
步驟一到七建議依序執行，後續步驟依賴前步驟產生的檔案
若 Hook 未觸發，請確認 .claude/settings.json 的 hooks 設定與 lint-on-write.sh 是否有執行權限
若 /scaffold 產生的檔案位置不符預期，可改用 cd todo-service 後再執行後續指令
Windows 環境下 Hook shell 腳本需確認 bash 路徑正確（settings.json 中的 command）
關鍵檔案
.claude/settings.json — 權限與 hooks 設定
.claude/hooks/lint-on-write.sh — console.log 偵測 Hook
.claude/skills/scaffold/SKILL.md
.claude/skills/code-review/SKILL.md
.claude/skills/test-runner/SKILL.md
.claude/skills/commit/SKILL.md
.claude/skills/pr-prepare/SKILL.md
.claude/skills/doc-gen/SKILL.md
User approved the plan
以下是完整的測試情境，你可以照步驟操作：

情境：建立 Todo API 服務（全流程實測）
角色：你是後端工程師，任務是建立一個小型 Node.js API 並走完完整開發流程。

步驟 1 — 測試 /scaffold
輸入：


/scaffold node-api todo-service
驗證：todo-service/ 目錄被建立，包含 src/index.js、tests/ 等標準骨架

步驟 2 — 測試 Hook（console.log 警告）
輸入：


請在 todo-service/src/routes/health.js 的 handler 中加入一行 console.log('health check called')
驗證：Claude 修改完檔案後，應主動提到偵測到 console.log 的警告

步驟 3 — 測試 /code-review
輸入：


/code-review todo-service/src
驗證：收到五維度評分報告，其中包含 console.log 相關的可維護性警告

步驟 4 — 測試 test-runner（自動觸發）
輸入：


請執行 todo-service 的測試
驗證：自動偵測框架並執行測試，顯示測試結果摘要

步驟 5 — 測試 /commit
先 git add todo-service/，再輸入：


/commit feat
驗證：git log --oneline -1 顯示格式如 feat(todo-service): 新增健康檢查路由與基礎 API 骨架

步驟 6 — 測試 /pr-prepare
輸入：


/pr-prepare main
驗證：輸出結構化的 PR 描述，包含摘要、測試計畫等 Markdown 段落

步驟 7 — 測試 /doc-gen
輸入：


/doc-gen todo-service/src api
驗證：產生包含端點路徑、方法、參數說明的 API 文件

注意：步驟需依序執行，後續步驟依賴前步驟產生的檔案。隨時可以問我任何一步的預期行為或問題排查。
