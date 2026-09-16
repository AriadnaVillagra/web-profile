import { Router } from 'express';
import { PortfolioController } from '../controllers/portfolio.controller.js';

const router = Router();

// Escucha en GET http://localhost:3001/api/portfolio
router.get('/', PortfolioController.getProjects);

export default router;