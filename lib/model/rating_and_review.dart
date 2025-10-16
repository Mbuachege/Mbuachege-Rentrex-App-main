class ReviewAndRating {
  String? placeName;
  String? imageUrl;
  String? rOF;
  String? review;
  String? date;

  ReviewAndRating(
      {this.placeName, this.imageUrl, this.rOF, this.review, this.date});

  ReviewAndRating.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'];
    imageUrl = json['imageUrl'];
    rOF = json['ROF'];
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeName'] = placeName;
    data['imageUrl'] = imageUrl;
    data['ROF'] = rOF;
    data['review'] = review;
    data['date'] = date;
    return data;
  }
}
