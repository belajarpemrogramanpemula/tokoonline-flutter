class Notifikasi {
  final int id;
  final String tanggal;
  final String userid;
  final String useridto;
  final String judul;
  final String keterangan;
  final String flag;
  final String st;
 
  Notifikasi({required this.id,required this.tanggal,required this.userid,required this.useridto,required this.judul,required this.keterangan,required this.flag,required this.st});
 
  factory Notifikasi.fromJson(Map<String, dynamic> json) {
    return Notifikasi(
      id: json['id'] as int,
      tanggal: json['tanggal'] as String,
      userid: json['userid'] as String,
      useridto: json['useridto'] as String,
      judul: json['judul'] as String,
      keterangan: json['keterangan'] as String,
      flag: json['flag'] as String,
      st: json['st'] as String
    );
  }
  
  factory Notifikasi.fromMap(Map<String, dynamic> map) {
    return Notifikasi(
      id: map['id'] as int,
      tanggal: map['tanggal'] as String,
      userid: map['userid'] as String,
      useridto: map['useridto'] as String,
      judul: map['judul'] as String,
      keterangan: map['keterangan'] as String,
      flag: map['flag'] as String,
      st: map['st'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['tanggal'] = tanggal;
    map['userid'] = userid;
    map['useridto'] = useridto;
    map['judul'] = judul;
    map['keterangan'] = keterangan;
    map['flag'] = flag;
    map['st'] = st;
    return map;
  }
}