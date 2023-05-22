import 'dart:convert';

class Region {
  final int id;
  final String nom;
  Region({
    required this.id,
    required this.nom,
  });

  Region copyWith({
    int? id,
    String? nom,
  }) {
    return Region(
      id: id ?? this.id,
      nom: nom ?? this.nom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  factory Region.fromMap(Map<String, dynamic> map) {
    return Region(
      id: map['id']?.toInt() ?? 0,
      nom: map['nom'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Region.fromJson(String source) => Region.fromMap(json.decode(source));

  @override
  String toString() => 'Region(id: $id, nom: $nom)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Region &&
      other.id == id &&
      other.nom == nom;
  }

  @override
  int get hashCode => id.hashCode ^ nom.hashCode;
}
