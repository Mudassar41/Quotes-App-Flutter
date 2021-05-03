class Images {
  String p_id, p_image;


  Images.data(this.p_id, this.p_image);
  Images();

  Map<String, dynamic> toMap() {
    return {
      'p_id': p_id,
      'p_image': p_image,
    };
  }
}
