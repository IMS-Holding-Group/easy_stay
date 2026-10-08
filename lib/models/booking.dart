/// Booking model class
/// Represents a room booking in the EasyStay application
class Booking {
  final int? id;
  final int userId;
  final int roomId;
  final DateTime bookingDate;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String status;

  Booking({
    this.id,
    required this.userId,
    required this.roomId,
    required this.bookingDate,
    this.checkInDate,
    this.checkOutDate,
    this.status = 'pending',
  });

  /// Convert Booking object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'room_id': roomId,
      'booking_date': bookingDate.toIso8601String(),
      'check_in_date': checkInDate?.toIso8601String(),
      'check_out_date': checkOutDate?.toIso8601String(),
      'status': status,
    };
  }

  /// Create Booking object from Map (from database)
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      roomId: map['room_id'] as int,
      bookingDate: DateTime.parse(map['booking_date'] as String),
      checkInDate: map['check_in_date'] != null
          ? DateTime.parse(map['check_in_date'] as String)
          : null,
      checkOutDate: map['check_out_date'] != null
          ? DateTime.parse(map['check_out_date'] as String)
          : null,
      status: map['status'] as String? ?? 'pending',
    );
  }
}
