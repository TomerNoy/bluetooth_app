class Account {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? phoneNumber;

  Account({
    this.id,
    this.email,
    this.phoneNumber,
    this.password,
    this.firstName,
    this.lastName,
  });

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        password = json['password'],
        phoneNumber = json['phoneNumber'];

  Map<String, dynamic>? toJson() {
    var jsonObj = {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };

    jsonObj.removeWhere((k, v) => v == null);
    return jsonObj.isEmpty ? null : jsonObj;
  }

  @override
  bool operator ==(dynamic act) => identical(this, act) || id == act.id;

  @override
  int get hashCode => id.hashCode;
}
