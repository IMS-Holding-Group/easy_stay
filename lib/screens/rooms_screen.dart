import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/booking.dart';
import '../services/db_service.dart';
import 'login_screen.dart';

/// Rooms screen
/// Displays available rooms and allows users to book them
class RoomsScreen extends StatefulWidget {
  final int userId;

  const RoomsScreen({super.key, required this.userId});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _dbService = DatabaseService.instance;
  List<Room> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  /// Load all available rooms from database
  Future<void> _loadRooms() async {
    try {
      final rooms = await _dbService.getAllRooms();
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ في تحميل الغرف: $e')));
      }
    }
  }

  /// Handle room booking
  Future<void> _bookRoom(Room room) async {
    try {
      final booking = Booking(
        userId: widget.userId,
        roomId: room.id!,
        bookingDate: DateTime.now(),
        status: 'confirmed',
      );

      await _dbService.insertBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حجز ${room.name} بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Print booking details to console for verification
      final allBookings = await _dbService.getUserBookings(widget.userId);
      print('=== Bookings for User ID ${widget.userId} ===');
      for (var booking in allBookings) {
        print(
          'Booking ID: ${booking.id}, Room ID: ${booking.roomId}, Date: ${booking.bookingDate}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ في الحجز: $e')));
      }
    }
  }

  /// Show booking confirmation dialog
  void _showBookingDialog(Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text(
          'هل تريد حجز ${room.name} بسعر ${room.price.toStringAsFixed(2)} ريال؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _bookRoom(room);
            },
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  /// Logout user
  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الغرف المتاحة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
          ? const Center(child: Text('لا توجد غرف متاحة'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    room.type,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${room.price.toStringAsFixed(2)} ريال',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          room.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showBookingDialog(room),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('احجز الآن'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
