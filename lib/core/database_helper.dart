import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recorded_item.dart';
import '../models/telemetry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flights.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE flights (
        id $idType,
        timestamp $textType,
        duration $integerType,
        maxAltitude $realType,
        maxSpeed $realType,
        maxPitch $realType,
        maxRoll $realType,
        status $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE telemetry (
        id $idType,
        flightId $integerType,
        timestamp $integerType,
        gyroX $realType,
        gyroY $realType,
        gyroZ $realType,
        magX $realType,
        magY $realType,
        magZ $realType,
        accelX $realType,
        accelY $realType,
        accelZ $realType,
        pitch $realType,
        roll $realType,
        yaw $realType,
        motor1Speed $realType,
        motor2Speed $realType,
        FOREIGN KEY (flightId) REFERENCES flights (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertFlight(RecordedFlight flight) async {
    final db = await database;
    return await db.insert('flights', flight.toMap());
  }

  Future<void> insertTelemetry(
      int flightId, List<Telemetry> telemetryList) async {
    final db = await database;
    final batch = db.batch();

    for (var i = 0; i < telemetryList.length; i++) {
      batch.insert('telemetry', {
        'flightId': flightId,
        'timestamp': i,
        ...telemetryList[i].toMap(),
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<RecordedFlight>> getAllFlights() async {
    final db = await database;
    final result = await db.query('flights', orderBy: 'timestamp DESC');

    return result.map((json) => RecordedFlight.fromMap(json)).toList();
  }

  Future<List<Telemetry>> getTelemetryForFlight(int flightId) async {
    final db = await database;
    final result = await db.query(
      'telemetry',
      where: 'flightId = ?',
      whereArgs: [flightId],
      orderBy: 'timestamp ASC',
    );

    return result.map((json) => Telemetry.fromMap(json)).toList();
  }

  Future<RecordedFlight?> getFlightById(int id) async {
    final db = await database;
    final maps = await db.query(
      'flights',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final flight = RecordedFlight.fromMap(maps.first);
    final telemetry = await getTelemetryForFlight(id);

    return RecordedFlight(
      id: flight.id,
      timestamp: flight.timestamp,
      duration: flight.duration,
      telemetryData: telemetry,
      maxAltitude: flight.maxAltitude,
      maxSpeed: flight.maxSpeed,
      maxPitch: flight.maxPitch,
      maxRoll: flight.maxRoll,
      status: flight.status,
    );
  }

  Future<int> deleteFlight(int id) async {
    final db = await database;
    return await db.delete(
      'flights',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
