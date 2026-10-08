import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/room.dart';
import '../models/booking.dart';

/// Database service class
/// Handles all SQLite database operations for EasyStay application
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('easystay.db');
    return _database!;
  }

  /// Initialize database and create tables
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Create all database tables
  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Rooms table
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        price REAL NOT NULL,
        image_path TEXT,
        description TEXT NOT NULL
      )
    ''');

    // Bookings table
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        room_id INTEGER NOT NULL,
        booking_date TEXT NOT NULL,
        check_in_date TEXT,
        check_out_date TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (room_id) REFERENCES rooms (id)
      )
    ''');

    // Insert initial room data (seed data)
    await _seedRooms(db);
  }

  /// Seed initial room data
  Future<void> _seedRooms(Database db) async {
    final rooms = [
      Room(
        name: 'Deluxe Suite',
        type: 'Suite',
        price: 299.99,
        description: 'Spacious suite with king bed and city view',
      ),
      Room(
        name: 'Standard Room',
        type: 'Standard',
        price: 149.99,
        description: 'Comfortable room with queen bed',
      ),
      Room(
        name: 'Executive Room',
        type: 'Executive',
        price: 199.99,
        description: 'Executive room with work desk and premium amenities',
      ),
      Room(
        name: 'Family Room',
        type: 'Family',
        price: 249.99,
        description: 'Large room perfect for families with multiple beds',
      ),
      Room(
        name: 'Presidential Suite',
        type: 'Suite',
        price: 499.99,
        description: 'Luxurious suite with living area and premium services',
      ),
      Room(
        name: 'Economy Room',
        type: 'Economy',
        price: 99.99,
        description: 'Affordable room with all essential amenities',
      ),
    ];

    for (var room in rooms) {
      await db.insert('rooms', room.toMap());
    }
  }

  /// User operations

  /// Insert a new user
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Room operations

  /// Get all rooms
  Future<List<Room>> getAllRooms() async {
    final db = await database;
    final maps = await db.query('rooms', orderBy: 'price ASC');
    return maps.map((map) => Room.fromMap(map)).toList();
  }

  /// Get room by ID
  Future<Room?> getRoomById(int id) async {
    final db = await database;
    final maps = await db.query('rooms', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return Room.fromMap(maps.first);
  }

  /// Booking operations

  /// Insert a new booking
  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap());
  }

  /// Get all bookings for a user
  Future<List<Booking>> getUserBookings(int userId) async {
    final db = await database;
    final maps = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'booking_date DESC',
    );
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  /// Get all bookings (for debugging/admin purposes)
  Future<List<Booking>> getAllBookings() async {
    final db = await database;
    final maps = await db.query('bookings', orderBy: 'booking_date DESC');
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
