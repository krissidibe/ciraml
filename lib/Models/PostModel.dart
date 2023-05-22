import 'dart:convert';

class Post {
  
   final String image;
   final String titre;
   final String contenu;
   final String updated_at;

  Post( this.image, this.titre, this.contenu, this.updated_at);
  
   

  Map<String, dynamic> toMap() {
    return {
     
      'image': image,
      'titre': titre,
      'contenu': contenu,
      'updated_at': updated_at,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
     
      map['image'] ?? '',
      map['titre'] ?? '',
      map['contenu'] ?? '',
      map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
