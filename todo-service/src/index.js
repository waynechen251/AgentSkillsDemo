import express from 'express';
import { healthRouter } from './routes/health.js';
import { errorHandler } from './middleware/error-handler.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/health', healthRouter);

app.use(errorHandler);

export const server = app.listen(PORT, () => {
  console.info(`todo-service 已啟動，監聽 port ${PORT}`);
});

export default app;
