class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  // Optionally add additional fields as needed

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // Factory constructor to create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Method to convert a User to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
