class Note {
  String? id; // Firestore document ID
  String title;
  String description;

  Note({
    this.id,
    required this.title,
    required this.description,
  });

  // Convert Note to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  // Convert Firestore document to Note
  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
