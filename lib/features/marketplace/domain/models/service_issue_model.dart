class ServiceIssueModel {
  final String id;
  final String serviceId;
  final String title;
  final String description;
  final String imagePath;

  ServiceIssueModel({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  factory ServiceIssueModel.fromAppwrite(Map<String, dynamic> data, String id) {
    return ServiceIssueModel(
      id: id,
      serviceId: data['serviceId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imagePath: data['imagePath'] ?? '',
    );
  }
}
