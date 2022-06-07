class Gambar {
  final int id;
  final String images;

  Gambar({required this.id, required this.images});

  factory Gambar.fromJson(Map<String, dynamic> json) {
    return Gambar(id: json['id'] as int, images: json['images'] as String);
  }
}