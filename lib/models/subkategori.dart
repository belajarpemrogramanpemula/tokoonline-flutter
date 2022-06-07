class Subkategori {
  final int id;
  final int idkategori;
  final String nama;
  final String kategori;
 
  Subkategori({required this.id,required this.idkategori,required this.nama,required this.kategori});
 
  factory Subkategori.fromJson(Map<String, dynamic> json) {
    return Subkategori(
      id: json['id'] as int,
      idkategori: json['idkategori'] as int,
      nama: json['nama'] as String,
      kategori: json['kategori'] as String
    );
  }
  
  factory Subkategori.fromMap(Map<String, dynamic> map) {
    return Subkategori(
      id: map['id'] as int,
      idkategori: map['idkategori'] as int,
      nama: map['nama'] as String,
      kategori: map['kategori'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['idkategori'] = idkategori;
    map['nama'] = nama;
    map['kategori'] = kategori;
    return map;
  }
}