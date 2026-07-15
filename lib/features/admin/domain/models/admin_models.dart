class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final bool isActive;
  final DateTime createdAt;

  AppUser({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.role, 
    this.avatar,
    required this.isActive, 
    required this.createdAt
  });

  String get avatarUrl {
    if (avatar != null && avatar!.isNotEmpty) return avatar!;
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0D47A1&color=fff&size=128';
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    // Tự động tìm dữ liệu dù Appwrite trả về kiểu bọc 'data' hay kiểu phẳng
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    
    return AppUser(
      id: map['\$id'] ?? data['id'] ?? data['userId'] ?? '',
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      avatar: data['avatar'],
      isActive: data['isActive'] ?? true,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class TechApplication {
  final String id;
  final String userId;
  final String fullName;
  final String specialty;
  final String experience;
  final String status; 
  final String? profileImage;
  final List<String>? documents; 
  final String? identityNumber;
  final String? identityCardFront;
  final String? identityCardBack;
  final double serviceRadius;
  final String? workSchedule;
  final String? businessName;
  final String? businessAddress;
  final double hourlyRate;
  final String? additionalInfo;
  final DateTime createdAt;

  TechApplication({
    required this.id, 
    required this.userId, 
    required this.fullName, 
    required this.specialty, 
    required this.experience, 
    required this.status, 
    this.profileImage,
    this.documents,
    this.identityNumber,
    this.identityCardFront,
    this.identityCardBack,
    this.serviceRadius = 10.0,
    this.workSchedule,
    this.businessName,
    this.businessAddress,
    this.hourlyRate = 0.0,
    this.additionalInfo,
    required this.createdAt
  });

  factory TechApplication.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    return TechApplication(
      id: map['\$id'] ?? '',
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      specialty: data['specialty'] ?? '',
      experience: data['experience'] ?? '',
      status: data['status'] ?? 'pending',
      profileImage: data['profileImage'],
      documents: data['documents'] != null ? List<String>.from(data['documents']) : null,
      identityNumber: data['identityNumber'],
      identityCardFront: data['identityCardFront'],
      identityCardBack: data['identityCardBack'],
      serviceRadius: (data['serviceRadius'] ?? 10.0).toDouble(),
      workSchedule: data['workSchedule'],
      businessName: data['businessName'],
      businessAddress: data['businessAddress'],
      hourlyRate: (data['hourlyRate'] ?? 0.0).toDouble(),
      additionalInfo: data['additionalInfo'],
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class BookingRecord {
  final String id;
  final String customerName;
  final String technicianName;
  final String serviceTitle;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  BookingRecord({
    required this.id,
    required this.customerName,
    required this.technicianName,
    required this.serviceTitle,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory BookingRecord.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    return BookingRecord(
      id: map['\$id'] ?? '',
      customerName: data['customerName'] ?? 'Customer',
      technicianName: data['technicianName'] ?? 'Unassigned',
      serviceTitle: data['serviceTitle'] ?? 'Service',
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class ServiceCategory {
  final String id;
  final String title; // Đổi name thành title cho đồng bộ DB
  final String? icon;
  final String? imagePath;
  final String? color;
  final bool isActive;
  final bool isPopular;
  final String? parentId;
  final int index;

  ServiceCategory({
    required this.id, 
    required this.title, 
    this.icon, 
    this.imagePath,
    this.color,
    required this.isActive,
    this.isPopular = false,
    this.parentId,
    this.index = 0,
  });

  factory ServiceCategory.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    return ServiceCategory(
      id: map['\$id'] ?? data['id'] ?? data['serviceId'] ?? '',
      title: data['title'] ?? data['name'] ?? '', // Ưu tiên title
      icon: data['icon'],
      imagePath: data['imagePath'],
      color: data['color']?.toString(),
      isActive: data['isActive'] ?? true,
      isPopular: (map['\$collectionId'] == 'popular_services') || (data['id']?.toString().startsWith('pop_') ?? false),
      parentId: data['parentId'],
      index: data['index'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'imagePath': imagePath,
      'color': color,
      'isActive': isActive,
      'parentId': parentId,
      'index': index,
    };
  }

  ServiceCategory copyWith({
    String? id,
    String? title,
    String? icon,
    String? imagePath,
    String? color,
    bool? isActive,
    bool? isPopular,
    String? parentId,
    int? index,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
      parentId: parentId ?? this.parentId,
      index: index ?? this.index,
    );
  }
}

class CouponModel {
  final String id;
  final String code;
  final String type; // 'percent' or 'fixed'
  final double value;
  final double minOrder;
  final DateTime expiry;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  CouponModel({
    required this.id, required this.code, required this.type,
    required this.value, required this.minOrder, required this.expiry,
    required this.usageLimit, required this.usedCount, required this.isActive,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    return CouponModel(
      id: map['\$id'] ?? data['\$id'] ?? '',
      code: data['code'] ?? '',
      type: data['type'] ?? 'percent',
      value: (data['value'] ?? 0).toDouble(),
      minOrder: (data['minOrder'] ?? 0).toDouble(),
      expiry: DateTime.tryParse(data['expiry'] ?? '') ?? DateTime.now(),
      usageLimit: data['usageLimit'] ?? 0,
      usedCount: data['usedCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }
}

class AuditLogModel {
  final String id;
  final String adminName;
  final String action;
  final String target;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  AuditLogModel({
    required this.id, 
    required this.adminName, 
    required this.action, 
    required this.target, 
    this.metadata,
    required this.createdAt
  });

  factory AuditLogModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : map;
    return AuditLogModel(
      id: map['\$id'] ?? data['\$id'] ?? '',
      adminName: data['adminName'] ?? 'System',
      action: data['action'] ?? '',
      target: data['target'] ?? '',
      metadata: data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
