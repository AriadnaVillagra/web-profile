import type { Request, Response, NextFunction } from 'express';
import { InMemoryPortfolioRepository } from '../../repositories/in-memory-portfolio.repository.js';


const portfolioRepository = new InMemoryPortfolioRepository();

export class PortfolioController {
  public static getProjects = async (
    _req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const projects = await portfolioRepository.getProjects();
      res.json(projects);
    } catch (error) {
      next(error);
    }
  };
}