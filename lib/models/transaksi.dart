class Transaksi {
  final String nota;
  final String tanggal;
  final String nama;
  final String cabang;
  final String keterangan;
  final String subtotal;
  final String subtotalrp;
  final String telp;
  final String email;
  final String telpcabang;
  final String emailcabang;
  final String flag;
  final String st;
 
  Transaksi({required this.nota,required this.tanggal,required this.nama,required this.cabang,required this.keterangan,required this.subtotal,required this.subtotalrp,required this.telp,required this.email,required this.telpcabang,required this.emailcabang,required this.flag,required this.st});
 
  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      nota: json['nota'] as String,
      tanggal: json['tanggal'] as String,
      nama: json['nama'] as String,
      cabang: json['cabang'] as String,
      keterangan: json['keterangan'] as String,
      subtotal: json['subtotal'] as String,
      subtotalrp: json['subtotalrp'] as String,
      telp: json['telp'] as String,
      email: json['email'] as String,
      telpcabang: json['telpcabang'] as String,
      emailcabang: json['emailcabang'] as String,
      flag: json['flag'] as String,
      st: json['st'] as String
    );
  }
  
  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      nota: map['nota'] as String,
      tanggal: map['tanggal'] as String,
      nama: map['nama'] as String,
      cabang: map['cabang'] as String,
      keterangan: map['keterangan'] as String,
      subtotal: map['subtotal'] as String,
      subtotalrp: map['subtotalrp'] as String,
      telp: map['telp'] as String,
      email: map['email'] as String,
      telpcabang: map['telpcabang'] as String,
      emailcabang: map['emailcabang'] as String,
      flag: map['flag'] as String,
      st: map['st'] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['nama'] = nama;
    map['tanggal'] = tanggal;
    map['cabang'] = cabang;
    map['subtotal'] = subtotal;
    map['subtotalrp'] = subtotalrp;
    map['telp'] = telp;
    map['email'] = email;
    map['telpcabang'] = telpcabang;
    map['emailcabang'] = emailcabang;
    map['flag'] = flag;
    map['st'] = st;
    return map;
  }
}