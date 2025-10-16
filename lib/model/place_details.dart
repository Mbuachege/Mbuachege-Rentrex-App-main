class PlaceDetails {
  String? placeName;
  String? address;
  String? duation;
  String? source;
  String? dest;
  String? amount;
  String? icon;
  String? image;

  PlaceDetails(
      {this.placeName,
      this.address,
      this.duation,
      this.source,
      this.dest,
      this.amount,
      this.icon,
      this.image});

  PlaceDetails.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'];
    address = json['address'];
    duation = json['duation'];
    source = json['source'];
    dest = json['dest'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeName'] = placeName;
    data['address'] = address;
    data['duation'] = duation;
    data['source'] = source;
    data['dest'] = dest;
    data['amount'] = amount;
    return data;
  }
}
