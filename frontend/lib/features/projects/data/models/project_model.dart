class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubUrl;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.githubUrl,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      technologies: List<String>.from(json['technologies']),
      githubUrl: json['githubUrl'],
    );
  }
}