class PersonDetails {
  String? name;
  String? phoneNumber;
  String? email;
  String? dob;
  String? imageUrl;

  PersonDetails(
      {this.name, this.phoneNumber, this.email, this.dob, this.imageUrl});

  PersonDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    dob = json['dob'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['dob'] = dob;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
