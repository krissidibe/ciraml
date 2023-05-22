import 'dart:convert';

class Cercle {
   final int id;
  final String non;
  Cercle({
    required this.id,
    required this.non,
  });

  Cercle copyWith({
    int? id,
    String? non,
  }) {
    return Cercle(
      id: id ?? this.id,
      non: non ?? this.non,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'non': non,
    };
  }

  factory Cercle.fromMap(Map<String, dynamic> map) {
    return Cercle(
      id: map['id']?.toInt() ?? 0,
      non: map['non'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cercle.fromJson(String source) => Cercle.fromMap(json.decode(source));

  @override
  String toString() => 'Cercle(id: $id, non: $non)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Cercle &&
      other.id == id &&
      other.non == non;
  }

  @override
  int get hashCode => id.hashCode ^ non.hashCode;
}
