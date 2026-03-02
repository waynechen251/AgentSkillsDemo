---
name: scaffold
description: 專案腳手架產生器 — 快速建立標準化的專案目錄結構
user-invocable: true
argument-hint: "<type> [name]  類型: node-api | react-app | python-cli | monorepo"
disable-model-invocation: true
---

# /scaffold — 專案腳手架產生器

## 參數

- `$0`（必填）：專案類型，可選值為 `node-api`、`react-app`、`python-cli`、`monorepo`
- `$1`（選填）：專案名稱，預設為 `my-project`

## 任務

根據 `$0` 指定的專案類型，建立對應的目錄結構與初始檔案。
專案名稱為 `$1`，若未提供則使用 `my-project`。

**注意**：只建立檔案結構，不執行任何套件安裝指令（如 `npm install`、`pip install`）。

## 各類型的目錄結構

### node-api

```
$1/
├── package.json          # name: $1, type: module, scripts: start/dev/test/lint
├── src/
│   ├── index.js          # Express 應用程式進入點
│   ├── routes/
│   │   └── health.js     # GET /health 路由
│   └── middleware/
│       └── error-handler.js  # 統一錯誤處理中介層
├── tests/
│   └── health.test.js    # 健康檢查端點測試
├── .env.example          # 環境變數範本（PORT, NODE_ENV）
└── README.md             # 專案說明（繁體中文）
```

### react-app

```
$1/
├── package.json          # name: $1, type: module, scripts: dev/build/test/lint
├── index.html            # Vite 入口 HTML
├── vite.config.js        # Vite 設定
├── src/
│   ├── main.jsx          # React 應用程式進入點
│   ├── App.jsx           # 根組件
│   ├── App.css           # 根組件樣式
│   └── components/
│       └── .gitkeep
├── tests/
│   └── App.test.jsx      # 根組件測試
└── README.md             # 專案說明（繁體中文）
```

### python-cli

```
$1/
├── pyproject.toml        # 專案元資料與依賴定義
├── src/
│   └── $1/               # 套件目錄（名稱同專案，連字號轉底線）
│       ├── __init__.py   # 版本資訊
│       ├── cli.py        # argparse CLI 進入點
│       └── core.py       # 核心業務邏輯
├── tests/
│   ├── __init__.py
│   └── test_core.py      # 核心邏輯測試
└── README.md             # 專案說明（繁體中文）
```

### monorepo

```
$1/
├── package.json          # workspaces 設定
├── packages/
│   ├── shared/
│   │   ├── package.json  # @$1/shared
│   │   └── src/
│   │       └── index.js  # 共用工具匯出
│   ├── api/
│   │   ├── package.json  # @$1/api, 依賴 @$1/shared
│   │   └── src/
│   │       └── index.js  # API 服務進入點
│   └── web/
│       ├── package.json  # @$1/web, 依賴 @$1/shared
│       └── src/
│           └── index.js  # Web 前端進入點
└── README.md             # 專案說明（繁體中文）
```

## 輸出要求

1. 按照上述結構建立所有檔案與目錄
2. 每個檔案都要有合理的初始內容（非空檔案）
3. `README.md` 使用繁體中文撰寫，包含專案名稱、簡介、快速開始步驟
4. 完成後列出所建立的檔案樹狀結構
