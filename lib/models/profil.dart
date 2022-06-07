class Profil {
  int id;
  String userid;
  String email;
  String nama;
  String alamat;
  String kota;
  String propinsi;
  String kodepos;
  String telp;

  Profil(
      {required this.id,
      required this.userid,
      required this.email,
      required this.nama,
      required this.alamat,
      required this.kota,
      required this.propinsi,
      required this.kodepos,
      required this.telp});


  factory Profil.fromMap(Map<String, dynamic> map) {
    return Profil(
      id: map['id'],
      userid: map['userid'],
      email: map['email'],
      nama: map['nama'],
      alamat: map['alamat'],
      kota: map['kota'],
      propinsi: map['propinsi'],
      kodepos: map['kodepos'],
      telp: map['telp'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['userid'] = userid;
    map['email'] = email;
    map['nama'] = nama;
    map['alamat'] = alamat;
    map['kota'] = kota;
    map['propinsi'] = propinsi;
    map['kodepos'] = kodepos;
    map['telp'] = telp;
    return map;
  }
}
