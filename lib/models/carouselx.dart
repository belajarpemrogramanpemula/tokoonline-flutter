class Carouselx {
  final int id;
  final String judul;
  final String thumbnail;
  final int idproduk;
  final String judul2;
  final String harga2;
  final String harga2x;
  final String deskripsi;
  final String thumbnail2;
 
  Carouselx({required this.id,required this.judul,required this.thumbnail,required this.idproduk,required this.judul2,required this.harga2,required this.harga2x,required this.deskripsi,required this.thumbnail2});
 
  factory Carouselx.fromJson(Map<String, dynamic> json) {
    return Carouselx(
      id: json['id'] as int,
      judul: json['judul'] as String,
      thumbnail: json['thumbnail'] as String,
      idproduk: json['idproduk'] as int,
      judul2: json['judul2'] as String,
      harga2: json['harga2'] as String,
      harga2x: json['harga2x'] as String,
      deskripsi: json['deskripsi'] as String,
      thumbnail2: json['thumbnail2'] as String
    );
  }
  
  factory Carouselx.fromMap(Map<String, dynamic> map) {
    return Carouselx(
      id: map['id'] as int,
      judul: map['judul'] as String,
      thumbnail: map['thumbnail'] as String,
      idproduk: map['idproduk'] as int,
      judul2: map['judul2'] as String,
      harga2: map['harga2'] as String,
      harga2x: map['harga2x'] as String,
      deskripsi: map['deskripsi'] as String,
      thumbnail2: map['thumbnail2'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['judul'] = judul;
    map['thumbnail'] = thumbnail;
    map['idproduk'] = idproduk;
    map['judul2'] = judul2;
    map['harga2'] = harga2;
    map['harga2x'] = harga2x;
    map['deskripsi'] = deskripsi;
    map['thumbnail2'] = thumbnail2;
    return map;
  }
}