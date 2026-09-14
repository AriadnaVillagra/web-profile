import type { Request, Response, NextFunction } from 'express';

export const errorMiddleware = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  console.error(`❌ Error detectado: ${err.message}`);

  res.status(500).json({
    status: 'error',
    message: err.message || 'Error interno del servidor',
  });
};