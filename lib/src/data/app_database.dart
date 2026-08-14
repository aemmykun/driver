import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../domain/ledger_models.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    return openDatabase(
      p.join(root, 'driver_ledger.db'),
      version: 1,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ledger_entries (
            id TEXT PRIMARY KEY,
            kind TEXT NOT NULL CHECK(kind IN ('income','expense')),
            occurred_at TEXT NOT NULL,
            description TEXT NOT NULL,
            amount_cents INTEGER NOT NULL CHECK(amount_cents > 0),
            gst_cents INTEGER NOT NULL CHECK(gst_cents >= 0 AND gst_cents <= amount_cents),
            business_use_bps INTEGER NOT NULL CHECK(business_use_bps BETWEEN 0 AND 10000),
            source TEXT NOT NULL,
            source_reference TEXT NOT NULL,
            category TEXT,
            evidence_status TEXT NOT NULL,
            receipt_path TEXT,
            created_at TEXT NOT NULL,
            UNIQUE(source, source_reference)
          )
        ''');
        await db.execute('''
          CREATE TABLE app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE declarations (
            id TEXT PRIMARY KEY,
            period_start TEXT NOT NULL,
            period_end TEXT NOT NULL,
            payload_hash TEXT NOT NULL,
            declaration_text TEXT NOT NULL,
            declared_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<LedgerEntry>> listEntries() async {
    final db = await database;
    final rows = await db.query('ledger_entries', orderBy: 'occurred_at DESC');
    return rows.map(LedgerEntry.fromMap).toList(growable: false);
  }

  Future<void> upsertEntry(LedgerEntry entry) async {
    final db = await database;
    await db.insert(
      'ledger_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteEntry(String id) async {
    final db = await database;
    await db.delete('ledger_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, String>> settings() async {
    final db = await database;
    final rows = await db.query('app_settings');
    return {for (final row in rows) row['key']! as String: row['value']! as String};
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> recordDeclaration({
    required String id,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String payloadHash,
    required String declarationText,
    required DateTime declaredAt,
  }) async {
    final db = await database;
    await db.insert('declarations', {
      'id': id,
      'period_start': periodStart.toUtc().toIso8601String(),
      'period_end': periodEnd.toUtc().toIso8601String(),
      'payload_hash': payloadHash,
      'declaration_text': declarationText,
      'declared_at': declaredAt.toUtc().toIso8601String(),
    });
  }
}
