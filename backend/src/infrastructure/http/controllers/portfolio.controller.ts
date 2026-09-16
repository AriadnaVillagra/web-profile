import type { Request, Response, NextFunction } from 'express';
import type { Portfolio } from '../../../domain/entities/portfolio.entity.js';

const MOCK_PORTFOLIO: Portfolio[] = [
  {
    id: '1',
    title: 'Mobile App Showcase',
    description: 'Demostración de aplicación mobile ejecutándose en mockup.',
    technologies: ['Flutter', 'Node.js', 'TypeScript'],
    videoUrl: 'http://localhost:3001/uploads/landing_compatible.mp4', // <-- URL que sirve Express
    deviceType: 'mobile',
    githubUrl: 'https://github.com/AriadnaVillagra/web_profile',
    featured: true,
  },
  {
    id: '2',
    title: 'Landing Page Responsive',
    description: 'Landing page en perspectiva mobile.',
    technologies: ['Flutter Web', 'Express'],
    videoUrl: 'http://localhost:3001/uploads/app_compatible.mp4',
    deviceType: 'mobile',
    liveUrl: 'https://mi-landing-demo.com',
    featured: false,
  },
];

export class PortfolioController {
  public static getProjects = (_req: Request, res: Response, next: NextFunction): void => {
    try {
      res.json(MOCK_PORTFOLIO);
    } catch (error) {
      next(error);
    }
  };
}