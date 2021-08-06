part of on_audio_query;

/// [GenreModel] contains all Genres Info
class GenreModel {
  GenreModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return genre [id]
  int get id => _info["_id"] is String ? int.parse(_info["_id"]) : _info["_id"];

  /// Return genre [name]
  String get genreName => _info["name"];

  /// Return genre [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  @Deprecated("message")
  String? get artwork => _info["artwork"];

  /// Return a map with all [keys] and [values] from specific genre.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}
