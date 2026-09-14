import { Router } from 'express';
import { ProjectController } from '../controllers/project.controller.js';

const router = Router();

router.get('/projects', ProjectController.getProjects);

export default router;