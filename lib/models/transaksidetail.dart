class Transaksidetail {
  final int id;
  final String nota;
  final String tanggal;
  final int idproduk;
  final String judul;
  final String harga;
  final String hargax;
  final String jumlah;
  final String subtotal;
  final String subtotalrp;
  final String thumbnail;
  final String userid;
  final int idcabang;
 
  Transaksidetail({required this.id,required this.nota,required this.tanggal,required this.idproduk,required this.judul,required this.harga,required this.hargax,required this.jumlah,required this.subtotal,required this.subtotalrp,required this.thumbnail,required this.userid,required this.idcabang});
 
  factory Transaksidetail.fromJson(Map<String, dynamic> json) {
    return Transaksidetail(
      id: json['id'] as int,
      nota: json['nota'] as String,
      tanggal: json['tanggal'] as String,
      idproduk: json['idproduk'] as int,
      judul: json['judul'] as String,
      harga: json['harga'] as String,
      hargax: json['hargax'] as String,
      jumlah: json['jumlah'] as String,
      subtotal: json['subtotal'] as String,
      subtotalrp: json['subtotalrp'] as String,
      thumbnail: json['thumbnail'] as String,
      userid: json['userid'] as String,
      idcabang: json['idcabang'] as int,
    );
  }
  
  factory Transaksidetail.fromMap(Map<String, dynamic> map) {
    return Transaksidetail(
      id: map['id'] as int,
      nota: map['nota'] as String,
      tanggal: map['tanggal'] as String,
      idproduk: map['idproduk'] as int,
      judul: map['judul'] as String,
      harga: map['harga'] as String,
      hargax: map['hargax'] as String,
      jumlah: map['jumlah'] as String,
      subtotal: map['subtotal'] as String,
      subtotalrp: map['subtotalrp'] as String,
      thumbnail: map['thumbnail'] as String,
      userid: map['userid'] as String,
      idcabang: map['idcabang'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['nota'] = nota;
    map['tanggal'] = tanggal;
    map['idproduk'] = idproduk;
    map['judul'] = judul;
    map['harga'] = harga;
    map['hargax'] = hargax;
    map['jumlah'] = jumlah;
    map['subtotal'] = subtotal;
    map['subtotalrp'] = subtotalrp;
    map['thumbnail'] = thumbnail;
    map['userid'] = userid;
    map['idcabang'] = idcabang;
    return map;
  }
}