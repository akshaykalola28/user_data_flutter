class User {
  int _id;
  String _firstName;
  String _lastName;
  String _email;

  User(this._firstName, this._lastName, this._email);

  User.withId(this._id, this._firstName, this._lastName, this._email);

  User.fromJson(Map<String, dynamic> map)
      : _firstName = map['first_name'],
        _lastName = map['first_name'],
        _email = map['email'];

  int get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;

  set firstName(String firstName) {
    this._firstName = firstName;
  }

  set lastName(String lastName) {
    this._lastName = lastName;
  }

  set email(String email) {
    this._email = email;
  }

  //Convert to Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;

    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    return map;
  }

  //Extract From Map
  User.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._email = map['email'];
  }
}
