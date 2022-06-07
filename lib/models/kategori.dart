class Kategori {
  final int id;
  final String nama;
 
  Kategori({required this.id,required this.nama});
 
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as int,
      nama: json['nama'] as String
    );
  }
  
  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'] as int,
      nama: map['nama'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['nama'] = nama;
    return map;
  }
}