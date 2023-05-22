import 'dart:convert';

class VideoModel {
  final String titre;
  final String idVideo;
  final String contenu;
  VideoModel({
    required this.titre,
    required this.idVideo,
    required this.contenu,
  });

  VideoModel copyWith({
    String? titre,
    String? idVideo,
    String? contenu,
  }) {
    return VideoModel(
      titre: titre ?? this.titre,
      idVideo: idVideo ?? this.idVideo,
      contenu: contenu ?? this.contenu,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'idVideo': idVideo,
      'contenu': contenu,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      titre: map['titre'] ?? '',
      idVideo: map['idVideo'] ?? '',
      contenu: map['contenu'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VideoModel(titre: $titre, idVideo: $idVideo, contenu: $contenu)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoModel &&
        other.titre == titre &&
        other.idVideo == idVideo &&
        other.contenu == contenu;
  }

  @override
  int get hashCode => titre.hashCode ^ idVideo.hashCode ^ contenu.hashCode;
}
