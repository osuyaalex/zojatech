class Users {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? image; // Make image optional
  final String? password; // Make password optional

  Users({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    this.password,
  });

  // Factory constructor to create a User from a Map
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '', // Default empty string if uid is missing
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      image: map['image'], // Can be null
      password: map['password'], // Can be null
    );
  }

  // Method to convert a User to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'password': password,
    };
  }
}
