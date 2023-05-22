import 'dart:convert';

class AvisCom {
  final String image;
  final String titre;
  final String contenu;
  AvisCom({
    required this.image,
    required this.titre,
    required this.contenu,
  });

  AvisCom copyWith({
    String? image,
    String? titre,
    String? contenu,
  }) {
    return AvisCom(
      image: image ?? this.image,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'titre': titre,
      'contenu': contenu,
    };
  }

  factory AvisCom.fromMap(Map<String, dynamic> map) {
    return AvisCom(
      image: map['image'] ?? '',
      titre: map['titre'] ?? '',
      contenu: map['contenu'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AvisCom.fromJson(String source) =>
      AvisCom.fromMap(json.decode(source));

  @override
  String toString() =>
      'AvisCom(image: $image, titre: $titre, contenu: $contenu)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvisCom &&
        other.image == image &&
        other.titre == titre &&
        other.contenu == contenu;
  }

  @override
  int get hashCode => image.hashCode ^ titre.hashCode ^ contenu.hashCode;
}
