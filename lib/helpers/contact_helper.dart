import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';

class ContactHelper {
    static final String _dbName = 'contacts.db';
    static final ContactHelper _instance = ContactHelper.internal();

    factory ContactHelper() => _instance;

    ContactHelper.internal();

    Database _db;

    Future<Database> get db async {
        if(_db != null) {
            return _db;

        } else {
            _db = await initDb();

            return _db;
        }
    }

    Future<Database> initDb() async {
        final databasesPath = await getDatabasesPath();

        final path = join(databasesPath, _dbName);

        return  await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
            await db.execute(
                'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)'
            );    
        });
    }

    Future<Contact> saveContact(Contact contact) async {
        Database dbContact = await db;
        contact.id = await dbContact.insert(contactTable, contact.toMap());

        return contact;
    }

    Future<Contact> getContact(int idContact) async {
        Database dbContact = await db;

        List<Map> maps = await dbContact.query(contactTable, 
            columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
            where: '$idColumn = ?',
            whereArgs: [idContact]
        );

        if(maps.length > 0) {
            return Contact.fromMap(maps.first);

        } else {
            return null;
        }
    }

    Future<int> deleteContact(int idContact) async {
        Database dbContact = await db;

        return await dbContact.delete(contactTable, where: '$idColumn = ?', whereArgs: [idContact]);
    }

    Future<int> updateContact(Contact contact) async {
        Database dbContact = await db;

        return await dbContact.update(contactTable, contact.toMap(), where: '$idColumn = ?', whereArgs: [contact.id]);
    }

    Future<List> getAllContacts() async {
        Database dbContact = await db;

        List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable ORDER BY $nameColumn");
        List<Contact> listContact = List();

        for(Map contactMap in listMap) {
            listContact.add(Contact.fromMap(contactMap));
        }

        return listContact;
    }

    Future<int> getNumber() async {
        Database dbContact = await db;

        return Sqflite.firstIntValue(await dbContact.rawQuery('SELECT COUNT($idColumn) FROM $contactTable'));
    }

    Future close() async {
        Database dbContact = await db;

        await dbContact.close(); 
    }
}

class Contact {
    int id;
    String name;
    String email;
    String phone;
    String img;

    Contact();
    
    Contact.fromMap(Map map) {
        this.id = map[idColumn];
        this.name = map[nameColumn];
        this.email = map[emailColumn];
        this.phone = map[phoneColumn];
        this.img = map[imgColumn];      
    }

    Map<String, dynamic> toMap() {
        Map<String, dynamic> map = {
            nameColumn: this.name,
            emailColumn: this.email,
            phoneColumn: this.phone,
            imgColumn: this.img
        };

        if(this.id != null) {
            map[idColumn] = this.id;
        }

        return map;
    }

    @override
    String toString() {
        return 'Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)';
    }
}