import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import portfolioRoutes from './infrastructure/http/routes/portfolio.routes.js';
import { loggerMiddleware } from './infrastructure/http/middlewares/logger.middleware.js';
import { errorMiddleware } from './infrastructure/http/middlewares/error.middleware.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());
app.use(loggerMiddleware);

// Servir la carpeta public/uploads como archivos estáticos HTTP
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

app.use('/api/portfolio', portfolioRoutes);
app.use(errorMiddleware);

app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});