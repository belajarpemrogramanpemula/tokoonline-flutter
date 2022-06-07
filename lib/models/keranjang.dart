class Keranjang {
  final int? id;
  final int idproduk;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;
  final int jumlah;
  final String userid;
  final String idcabang;

  Keranjang({this.id, required this.idproduk,required this.judul,required this.harga, required this.hargax, required this.thumbnail, required this.jumlah, required this.userid, required this.idcabang});

  factory Keranjang.fromJson(Map<String, dynamic> json) {
    return Keranjang(
      id: json['id'] as int,
      idproduk: json['idproduk'] as int,
      judul: json['judul'] as String,
      harga: json['harga'] as String,
      hargax: json['hargax'] as String,
      thumbnail: json['thumbnail'] as String,
      jumlah: json['jumlah'] as int,
      userid: json['userid'] as String,
      idcabang: json['idcabang'] as String,
    );
  }

  factory Keranjang.fromMap(Map<String, dynamic> map) {
    return Keranjang(
      id: map['id'] as int,
      idproduk: map['idproduk'] as int,
      judul: map['judul'] as String,
      harga: map['harga'] as String,
      hargax: map['hargax'] as String,
      thumbnail: map['thumbnail'] as String,
      jumlah: map['jumlah'] as int,
      userid: map['userid'] as String,
      idcabang: map['idcabang'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['idproduk'] = id;
    map['judul'] = judul;
    map['harga'] = harga;
    map['hargax'] = hargax;
    map['thumbnail'] = thumbnail;
    map['jumlah'] = jumlah;
    map['userid'] = userid;
    map['idcabang'] = idcabang;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "idproduk": idproduk,
        "judul": judul,
        "harga": harga,
        "hargax": hargax,
        "thumbnail": thumbnail,
        "jumlah": jumlah,
        "userid": userid,
        "idcabang": idcabang
      };
}
