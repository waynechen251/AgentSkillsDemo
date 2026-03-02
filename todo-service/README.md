# todo-service

Todo 待辦事項 REST API 服務，基於 Express.js 建構，採用 ES Module 規範。

## 功能特色

- `GET /health` — 健康檢查端點
- 統一錯誤處理中介層
- 支援 `.env` 環境變數設定

## 快速開始

### 前置條件

- Node.js >= 20.0.0
- npm >= 10.0.0

### 安裝步驟

1. 複製環境變數範本：

```bash
cp .env.example .env
```

2. 安裝依賴套件：

```bash
npm install
```

3. 啟動開發伺服器：

```bash
npm run dev
```

服務預設運行於 <http://localhost:3000>。

## 可用指令

| 指令 | 說明 |
|------|------|
| `npm start` | 生產模式啟動 |
| `npm run dev` | 開發模式啟動（支援熱重載） |
| `npm test` | 執行測試 |
| `npm run lint` | 程式碼風格檢查 |

## API 端點

### `GET /health`

回傳服務健康狀態。

**回應範例：**

```json
{
  "status": "ok",
  "service": "todo-service",
  "timestamp": "2026-03-02T00:00:00.000Z"
}
```

## 專案結構

```
todo-service/
├── src/
│   ├── index.js              # 應用程式進入點
│   ├── routes/
│   │   └── health.js         # 健康檢查路由
│   └── middleware/
│       └── error-handler.js  # 統一錯誤處理
├── tests/
│   └── health.test.js        # 端點測試
├── .env.example              # 環境變數範本
└── package.json
```
