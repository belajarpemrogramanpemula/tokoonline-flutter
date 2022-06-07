class Produk {
  final int id;
  final int idkategori;
  final String judul;
  final String harga;
  final String hargax;
  final String deskripsi;
  final String thumbnail;
 
  Produk({required this.id,required this.idkategori,required this.judul,required this.harga,required this.hargax,required this.deskripsi,required this.thumbnail});
 
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as int,
      idkategori: json['idkategori'] as int,
      judul: json['judul'] as String,
      harga: json['harga'] as String,
      hargax: json['hargax'] as String,
      deskripsi: json['deskripsi'] as String,
      thumbnail: json['thumbnail'] as String
    );
  }
  
  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'] as int,
      idkategori: map['idkategori'] as int,
      judul: map['judul'] as String,
      harga: map['harga'] as String,
      hargax: map['hargax'] as String,
      deskripsi: map['deskripsi'] as String,
      thumbnail: map['thumbnail'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['idkategori'] = idkategori;
    map['judul'] = judul;
    map['harga'] = harga;
    map['hargax'] = hargax;
    map['deskripsi'] = deskripsi;
    map['thumbnail'] = thumbnail;
    return map;
  }
}