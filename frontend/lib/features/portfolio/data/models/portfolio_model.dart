class PortfolioModel {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? videoUrl;
  final String? deviceFrameUrl;
  final String? deviceType;
  final String? liveUrl;
  final String? githubUrl;
  final bool featured;

  PortfolioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.videoUrl,
    this.deviceFrameUrl,
    this.deviceType,
    this.liveUrl,
    this.githubUrl,
    this.featured = false,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] ?? []),
      videoUrl: json['videoUrl'] as String?,
      deviceFrameUrl: json['deviceFrameUrl'] as String?,
      deviceType: json['deviceType'] as String?,
      liveUrl: json['liveUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      featured: json['featured'] as bool? ?? false,
    );
  }
}
