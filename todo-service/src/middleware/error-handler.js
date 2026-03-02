/**
 * 統一錯誤處理中介層
 * 攔截所有未處理的錯誤並回傳標準化 JSON 錯誤回應
 */
export function errorHandler(err, _req, res, _next) {
  const status = err.status || err.statusCode || 500;
  const message = err.message || '伺服器內部錯誤';

  res.status(status).json({
    error: {
      status,
      message,
    },
  });
}
