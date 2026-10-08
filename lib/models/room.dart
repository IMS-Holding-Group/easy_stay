/// Room model class
/// Represents a hotel room in the EasyStay application
class Room {
  final int? id;
  final String name;
  final String type;
  final double price;
  final String? imagePath;
  final String description;

  Room({
    this.id,
    required this.name,
    required this.type,
    required this.price,
    this.imagePath,
    required this.description,
  });

  /// Convert Room object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'image_path': imagePath,
      'description': description,
    };
  }

  /// Create Room object from Map (from database)
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      price: (map['price'] as num).toDouble(),
      imagePath: map['image_path'] as String?,
      description: map['description'] as String,
    );
  }
}
