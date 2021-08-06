import MediaPlayer

public func loadSongItem(song: MPMediaItem) -> [String: Any?] {
    // TODO Add others png option
    let artwork = song.artwork?.image(at: CGSize(width: 150, height: 150))?.jpegData(compressionQuality: 1)
    let fileExt = song.assetURL?.pathExtension ?? ""
    let sizeInBytes = song.value(forProperty: "fileSize") as? Int
    let songData: [String: Any?] = [
        "_id": song.persistentID,
        "_data": song.assetURL?.absoluteString,
        "_uri": song.assetURL?.absoluteString,
        "_display_name": "\(song.artist ?? "") - \(song.title ?? "").\(fileExt)",
        "_display_name_wo_ext": "\(song.artist ?? "") - \(song.title ?? "")",
        "_size": sizeInBytes,
        "album": song.albumTitle,
        "album_id": song.albumPersistentID,
        "artist": song.artist,
        "artist_id": song.artistPersistentID,
        "bookmark": String.init(song.bookmarkTime),
        "composer": song.composer,
        "date_added": song.dateAdded.timeIntervalSince1970,
        "date_modified": 0,
        "duration": song.playbackDuration * 1000,
        "title": song.title,
        "track": song.albumTrackNumber,
        "artwork": artwork,
        "file_extension": fileExt,
    ]
    return songData
}

public func formatSongList(args: [String: Any], allSongs: [[String: Any?]]) -> [[String: Any?]] {
    var tempList = allSongs
    let order = args["orderType"] as? Int
    let sortType = args["sortType"] as? Int
    
    //
    switch sortType {
    case 3:
        tempList.sort { (val1, val2) -> Bool in
            (val1["duration"] as! Double) > (val2["duration"] as! Double)
        }
    case 4:
        tempList.sort { (val1, val2) -> Bool in
            (val1["date_added"] as! Int) > (val2["date_added"] as! Int)
        }
    case 5:
        tempList.sort { (val1, val2) -> Bool in
            (val1["_size"] as! Int) > (val2["_size"] as! Int)
        }
    case 6:
        tempList.sort { (val1, val2) -> Bool in
            (val1["_display_name"] as! String) > (val2["_display_name"] as! String)
        }
    default:
        break
    }
    
    //
    if order == 1 {
        tempList.reverse()
    }
    return tempList
}

//Albums

func loadAlbumItem(album: MPMediaItemCollection) -> [String: Any?] {
    let artwork = album.items[0].artwork?.image(at: CGSize(width: 150, height: 150))?.jpegData(compressionQuality: 1)
    let albumData: [String: Any?] = [
        "numsongs": album.count,
        "artist": album.items[0].albumArtist,
        "_id": album.items[0].persistentID,
        "album": album.items[0].albumTitle,
        "album_art": artwork,
        "artist_id": album.items[0].albumArtistPersistentID,
        "album_id": album.items[0].albumPersistentID
    ]
    return albumData
}

public func formatAlbumList(args: [String: Any], allAlbums: [[String: Any?]]) -> [[String: Any?]] {
    var tempList = allAlbums
    let order = args["orderType"] as? Int
    let sortType = args["sortType"] as? Int
    
    if sortType == 3 {
        tempList.sort { (val1, val2) -> Bool in
            (val1["numsongs"] as! Int) > (val2["numsongs"] as! Int)
        }
    }
    
    //
    if order == 1 {
        tempList.reverse()
    }
    return tempList
}


//Artists

func loadArtistItem(artist: MPMediaItemCollection) -> [String: Any?] {
    //Get all albums from artist
    let albumsCursor = MPMediaQuery.albums()
    albumsCursor.addFilterPredicate(MPMediaPropertyPredicate.init(value: artist.items[0].albumArtist, forProperty: MPMediaItemPropertyAlbumArtist))
    var finalCount: [String] = Array()
    
    let albums = albumsCursor.collections
    
    //Normally when song don't have a album, will be "nil" or "unknown",
    //Here we'll "filter" the albums, removing this "non-albums".
    //So, if multiples songs don't has a defined album, will be count only 1.
    for album in albums! {
        let itemAlbum = album.items[0].albumTitle
        if itemAlbum != nil && !finalCount.contains(itemAlbum!) {
            finalCount.append(itemAlbum!)
        }
    }
    
    //
    let artistData: [String: Any?] = [
        "_id": artist.items[0].artistPersistentID,
        "artist": artist.items[0].artist,
        "number_of_albums": finalCount.count,
        "number_of_tracks": artist.count
    ]
    return artistData
}

public func formatArtistList(args: [String: Any], allArtists: [[String: Any?]]) -> [[String: Any?]] {
    var tempList = allArtists
    let order = args["orderType"] as? Int
    let sortType = args["sortType"] as? Int
    
    switch sortType {
    case 3:
        tempList.sort { (val1, val2) -> Bool in
            (val1["number_of_tracks"] as! Int) > (val2["number_of_tracks"] as! Int)
        }
    case 4:
        tempList.sort { (val1, val2) -> Bool in
            (val1["number_of_albums"] as! Int) > (val2["number_of_albums"] as! Int)
        }
    default:
        break
    }
    
    //
    if order == 1 {
        tempList.reverse()
    }
    return tempList
}

//Genres

func loadGenreItem(genre: MPMediaItemCollection) -> [String: Any?] {
    //Get all albums from artist
//    let albumsCursor = MPMediaQuery.albums()
//    albumsCursor.addFilterPredicate(MPMediaPropertyPredicate.init(value: artist.items[0].albumArtist, forProperty: MPMediaItemPropertyAlbumArtist))
//    var finalCount: [String] = Array()
    
//    let albums = albumsCursor.collections
    
    //Normally when song don't have a album, will be "nil" or "unknown",
    //Here we'll "filter" the albums, removing this "non-albums".
    //So, if multiples songs don't has a defined album, will be count only 1.
//    for album in albums! {
//        let itemAlbum = album.items[0].albumTitle
//        if itemAlbum != nil && !finalCount.contains(itemAlbum!) {
//            finalCount.append(itemAlbum!)
//        }
//    }
    
    //
    let genreData: [String: Any?] = [
        "_id": genre.items[0].genrePersistentID,
        "name": genre.items[0].genre,
        "number_of_songs": genre.count
    ]
    print(genreData)
    return genreData
}

public func formatGenreList(args: [String: Any], allGenres: [[String: Any?]]) -> [[String: Any?]] {
    var tempList = allGenres
    let order = args["orderType"] as? Int

    //
    if order == 1 {
        tempList.reverse()
    }
    return tempList
}
