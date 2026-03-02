#!/usr/bin/env bash
# ============================================================
# PostToolUse Hook: lint-on-write
# 觸發時機：Claude 使用 Write 或 Edit 工具後
# 功能：檢查 JS/TS 檔案中是否殘留 console.log
# 教學重點：JSON stdin/stdout 協定、exit code 語意
# ============================================================
#
# Hook JSON 協定說明：
#   - Claude Code 會透過 stdin 傳入 JSON，包含工具名稱與參數
#   - Hook 透過 stdout 回傳 JSON，可包含以下欄位：
#     - systemMessage: 顯示給 Claude 的系統訊息（非阻擋）
#     - stopExecution: 若為 true 則中止後續流程
#   - exit code 0 = 成功，非 0 = Hook 本身執行失敗（不影響 Claude）
# ============================================================

# 從 stdin 讀取 JSON 輸入
INPUT=$(cat)

# 檢查是否安裝 jq，若無則靜默跳過
if ! command -v jq &> /dev/null; then
  echo '{}'
  exit 0
fi

# 解析被寫入的檔案路徑
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

# 若無法取得路徑，靜默跳過
if [ -z "$FILE_PATH" ]; then
  echo '{}'
  exit 0
fi

# 僅檢查 JS/TS 檔案
case "$FILE_PATH" in
  *.js|*.ts|*.jsx|*.tsx|*.mjs|*.mts)
    ;;
  *)
    echo '{}'
    exit 0
    ;;
esac

# 檢查檔案是否存在
if [ ! -f "$FILE_PATH" ]; then
  echo '{}'
  exit 0
fi

# 搜尋 console.log 殘留（排除註解中的）
MATCHES=$(grep -n 'console\.log' "$FILE_PATH" 2>/dev/null | grep -v '^\s*//' | grep -v '^\s*\*' || true)

if [ -n "$MATCHES" ]; then
  # 計算出現次數
  COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')

  # 組合警告訊息
  WARNING="⚠️ 偵測到 ${COUNT} 處 console.log 殘留於 ${FILE_PATH}：\n"
  while IFS= read -r line; do
    WARNING="${WARNING}  第 ${line}\n"
  done <<< "$MATCHES"
  WARNING="${WARNING}請在提交前移除不必要的 console.log。"

  # 透過 systemMessage 回傳警告（非阻擋，不會中止流程）
  echo "{\"systemMessage\": \"${WARNING}\"}"
else
  echo '{}'
fi

exit 0
