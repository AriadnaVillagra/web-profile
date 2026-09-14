import type { Request, Response, NextFunction } from 'express';

// Datos de prueba (por ahora mockeados)
const MOCK_PROJECTS = [
  {
    id: '1',
    title: 'Portafolio Web Personal',
    description: 'Mi sitio web profesional construido con Flutter Web y Node.js Express API.',
    technologies: ['Flutter', 'TypeScript', 'Node.js', 'Express'],
    githubUrl: 'https://github.com/tu-usuario/web_profile',
  },
  {
    id: '2',
    title: 'E-commerce API',
    description: 'API REST para gestión de productos y carritos de compra.',
    technologies: ['Node.js', 'Express', 'TypeScript'],
  },
];

export class ProjectController {
  public static getProjects = (_req: Request, res: Response, next: NextFunction): void => {
    try {
      res.json(MOCK_PROJECTS);
    } catch (error) {
      next(error); // Pasa el error al middleware global de errores
    }
  };
}