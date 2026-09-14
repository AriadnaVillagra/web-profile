import express from 'express';
import cors from 'cors';
import projectRoutes from './routes/project.routes';
import { loggerMiddleware } from './middlewares/logger.middleware';
import { errorMiddleware } from './middlewares/error.middleware';

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares globales de entrada
app.use(cors());
app.use(express.json());
app.use(loggerMiddleware);

// Rutas de la API
app.use('/api', projectRoutes);

// Middleware global para captura de errores (debe ir al final de las rutas)
app.use(errorMiddleware);

app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});