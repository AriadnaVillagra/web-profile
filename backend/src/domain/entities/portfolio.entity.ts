export interface Portfolio {
  id: string;
  title: string;
  description: string;
  technologies: string[];
  videoUrl?: string;          // Para el video MP4/WebM
  deviceFrameUrl?: string;   // Para el PNG de la carcasa del celular
  deviceType?: 'mobile' | 'desktop' | 'none'; // Define si se renderiza dentro del celular
  liveUrl?: string;
  liveUrlLabel?: string;
  githubUrl?: string;
  featured?: boolean;
}