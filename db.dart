import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Balance { final double amount; final String side; Balance(this.amount,this.side); }

class DB {
  static late Database db;
  static Future<void> init() async {
    db=await openDatabase(join(await getDatabasesPath(),'agent_hisab.db'),version:2,
      onCreate:(d,v)async{await _create(d);},
      onUpgrade:(d,oldV,newV)async{if(oldV<2){await d.execute('CREATE TABLE IF NOT EXISTS agents(name TEXT PRIMARY KEY, groupId TEXT DEFAULT \'\')');await d.execute('INSERT OR IGNORE INTO agents(name) SELECT DISTINCT agent FROM hisab');}});
  }
  static Future<void> _create(DatabaseExecutor d) async {
    await d.execute('''CREATE TABLE hisab(
      id INTEGER PRIMARY KEY AUTOINCREMENT, agent TEXT NOT NULL, date TEXT NOT NULL,
      d1 TEXT,d2 TEXT,d3 TEXT,d4 TEXT,d5 TEXT,d6 TEXT,d7 TEXT,d8 TEXT,
      g1 TEXT,g2 TEXT,g3 TEXT,g4 TEXT,g5 TEXT,g6 TEXT,g7 TEXT,g8 TEXT,
      opening REAL DEFAULT 0, openingSide TEXT DEFAULT '', closing REAL DEFAULT 0, closingSide TEXT DEFAULT '')''');
    await d.execute('CREATE UNIQUE INDEX agent_date ON hisab(agent,date)');
    await d.execute('CREATE TABLE agents(name TEXT PRIMARY KEY, groupId TEXT DEFAULT \'\')');
  }
  static Future<Map<String,dynamic>?> day(String agent,String date)async{final r=await db.query('hisab',where:'agent=? AND date=?',whereArgs:[agent,date],limit:1);return r.isEmpty?null:r.first;}
  static Future<Balance> previous(String agent,String date)async{final r=await db.rawQuery('SELECT closing,closingSide FROM hisab WHERE agent=? AND date<? ORDER BY date DESC,id DESC LIMIT 1',[agent,date]);if(r.isEmpty)return Balance(0,'');return Balance((r.first['closing'] as num?)?.toDouble()??0,r.first['closingSide']?.toString()??'');}
  static Future<List<String>> agents()async{final r=await db.rawQuery('SELECT name FROM agents WHERE name<>\'\' ORDER BY name COLLATE NOCASE');return r.map((e)=>e['name'].toString()).toList();}
  static Future<void> ensureAgent(String name)async{if(name.trim().isNotEmpty)await db.insert('agents',{'name':name.trim()},conflictAlgorithm:ConflictAlgorithm.ignore);}
  static Future<String> groupId(String name)async{final r=await db.query('agents',columns:['groupId'],where:'name=?',whereArgs:[name],limit:1);return r.isEmpty?'':(r.first['groupId']?.toString()??'');}
  static Future<void> setGroupId(String name,String groupId)async{await ensureAgent(name);await db.update('agents',{'groupId':groupId.trim()},where:'name=?',whereArgs:[name]);}
  static Future<void> save({required String agent,required String date,required List<String>d,required List<String>g,required double opening,required String openingSide,required double closing,required String closingSide})async{
    await ensureAgent(agent);final x=<String,dynamic>{'agent':agent,'date':date,'opening':opening,'openingSide':openingSide,'closing':closing,'closingSide':closingSide};
    for(int i=0;i<8;i++){x['d${i+1}']=d[i].isEmpty?null:d[i];x['g${i+1}']=g[i].isEmpty?null:g[i];}
    await db.insert('hisab',x,conflictAlgorithm:ConflictAlgorithm.replace);
  }
  static Future<List<Map<String,dynamic>>> history(String agent)=>db.query('hisab',where:'agent=?',whereArgs:[agent],orderBy:'date DESC,id DESC');
}
