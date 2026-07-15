class ProductModel {
  final String id;
  final String name;
  final int price;
  final String imagePath;
  final String description;
  final List<String> relatedIssueIds;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.relatedIssueIds,
  });

  factory ProductModel.fromAppwrite(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      relatedIssueIds: List<String>.from(data['relatedIssueIds'] ?? []),
    );
  }
}
