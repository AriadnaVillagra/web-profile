import type { Portfolio } from '../../domain/entities/portfolio.entity.js';

export class InMemoryPortfolioRepository {
  private readonly projects: Portfolio[] = [
    {
      id: 'landing-page',
      title: 'Landing Page Oficial',
      description:
        'Lideré como PM Owner y desarrollé el Front-end de la landing page. Propuse e implementé el concepto Neobrutalista colaborando con UI/UX designers. Coordiné a 2 desarrolladores mediante Jira e implementé una arquitectura por features limpia en React Web.',
      technologies: [
        'React',
        'JavaScript',
        'Jira',
        'Agile',
        'Feature-First Architecture',
        'Neobrutalism UI',
      ],
      videoUrl: 'http://localhost:3001/uploads/landing_compatible.mp4',
      deviceType: 'mobile',
      featured: true,
      liveUrl: 'https://banana-software.com/en',
      liveUrlLabel: 'Ver Web / Landing',
    },
   {
  id: 'artplacer-mobile',
  title: 'ArtPlacer Mobile & White-Label Apps',
  description:
    'Co-lideré el desarrollo mobile y la migración integral de una base de código con más de 5 años de antigüedad hacia Flutter moderno. Trabajé en colaboración con un desarrollador Unity para la integración de un plugin 3D/AR en la app. Adicionalmente, gestioné y ejecuté múltiples despliegues White-Label en Google Play Store y Apple App Store para clientes exclusivos del sector de arte.',
  technologies: [
    'Flutter',
    'Dart',
    'Unity Plugin Integration',
    'iOS / App Store Connect',
    'Android / Play Console',
    'White-Label Architecture',
    'Mobile Migration'
  ],
  videoUrl: 'http://localhost:3001/uploads/app_compatible.mp4',
  deviceType: 'mobile',
  liveUrl: 'https://play.google.com/store/apps/details?id=com.artplacer.artplacer&hl=es_419',
  liveUrlLabel: 'Ver en Play Store',
  featured: true
}
  ];

  public async getProjects(): Promise<Portfolio[]> {
    return this.projects;
  }
}