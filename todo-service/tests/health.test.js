import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

// 使用 Node.js 內建測試框架對健康檢查端點進行測試
// PORT=0 讓 OS 自動分配可用 port，避免固定 port 衝突
process.env.PORT = '0';

describe('GET /health', () => {
  it('應回傳 status ok 與服務名稱', async () => {
    const { server } = await import('../src/index.js');

    const { port } = server.address();
    const response = await fetch(`http://localhost:${port}/health`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
    assert.equal(body.service, 'todo-service');
    assert.ok(body.timestamp, '應包含 timestamp 欄位');

    await new Promise((resolve) => server.close(resolve));
  });
});
