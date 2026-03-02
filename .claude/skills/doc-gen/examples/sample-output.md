# API 文件範例輸出

> 此檔案是 `/doc-gen` Skill 的範例輸出，展示 `api` 類型文件的格式。

---

# 使用者認證 API

## 概述

使用者認證模組提供 JWT 為基礎的認證機制，支援使用者註冊、登入、登出與 token 更新。

## Base URL

```
/api/v1/auth
```

## 端點

### POST /register

註冊新使用者帳號。

**Request Body**

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| `username` | string | 是 | 使用者名稱（3-20 字元） |
| `email` | string | 是 | 電子郵件 |
| `password` | string | 是 | 密碼（最少 8 字元） |

**Response 201**

```json
{
  "id": "usr_abc123",
  "username": "demo_user",
  "email": "demo@example.com",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

**Error Responses**

| 狀態碼 | 說明 |
|--------|------|
| 400 | 請求格式錯誤或欄位驗證失敗 |
| 409 | 使用者名稱或電子郵件已被使用 |

---

### POST /login

使用者登入取得 JWT token。

**Request Body**

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| `email` | string | 是 | 電子郵件 |
| `password` | string | 是 | 密碼 |

**Response 200**

```json
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG...",
  "expiresIn": 3600
}
```

---

### POST /logout

登出並撤銷目前的 token。

**Headers**

| 欄位 | 說明 |
|------|------|
| `Authorization` | `Bearer <accessToken>` |

**Response 204**

無回應內容。

---

## 錯誤格式

所有錯誤回應遵循統一格式：

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "請求格式錯誤",
    "details": [
      {
        "field": "email",
        "message": "無效的電子郵件格式"
      }
    ]
  }
}
```

## 認證流程圖

```
使用者 → POST /login → 取得 accessToken + refreshToken
     → 使用 accessToken 存取受保護的 API
     → accessToken 過期 → POST /refresh → 取得新 accessToken
     → 登出 → POST /logout → 撤銷所有 token
```
