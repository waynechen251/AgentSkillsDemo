import { Router } from 'express';

export const healthRouter = Router();

healthRouter.get('/', (_req, res) => {
  console.log('health check called');
  res.json({
    status: 'ok',
    service: 'todo-service',
    timestamp: new Date().toISOString(),
  });
});
