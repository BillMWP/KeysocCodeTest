import Foundation
import RealmSwift
// MARK: - SongListModel
class SongListModel: Codable {
    var resultCount: Int
    var results: [SongModel]
    
    init(resultCount: Int, results: [SongModel]) {
        self.resultCount = resultCount
        self.results = results
    }
}

// MARK: - Result
class SongModel: Codable {
    var wrapperType: String?
    var kind: String?
    var artistID, collectionID, trackID: Int?
    var artistName, collectionName, trackName, collectionCensoredName: String?
    var trackCensoredName: String?
    var artistViewURL, collectionViewURL, trackViewURL: String?
    var previewURL: String?
    var artworkUrl30, artworkUrl60, artworkUrl100: String?
    var collectionPrice, trackPrice: Double?
    var releaseDate: String?
    var collectionExplicitness, trackExplicitness: String?
    var discCount, discNumber, trackCount, trackNumber: Int?
    var trackTimeMillis: Int?
    var country: String?
    var currency: String?
    var primaryGenreName: String?
    var isStreamable: Bool?
    var collectionArtistName: String?
    var collectionArtistID: Int?
    var collectionArtistViewURL: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable, collectionArtistName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
    }
    
    init(wrapperType: String, kind: String, artistID: Int, collectionID: Int, trackID: Int, artistName: String, collectionName: String, trackName: String, collectionCensoredName: String, trackCensoredName: String, artistViewURL: String, collectionViewURL: String, trackViewURL: String, previewURL: String, artworkUrl30: String, artworkUrl60: String, artworkUrl100: String, collectionPrice: Double?, trackPrice: Double?, releaseDate: String, collectionExplicitness: String, trackExplicitness: String, discCount: Int, discNumber: Int, trackCount: Int, trackNumber: Int, trackTimeMillis: Int, country: String, currency: String, primaryGenreName: String, isStreamable: Bool, collectionArtistName: String?, collectionArtistID: Int?, collectionArtistViewURL: String?) {
        self.wrapperType = wrapperType
        self.kind = kind
        self.artistID = artistID
        self.collectionID = collectionID
        self.trackID = trackID
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.collectionCensoredName = collectionCensoredName
        self.trackCensoredName = trackCensoredName
        self.artistViewURL = artistViewURL
        self.collectionViewURL = collectionViewURL
        self.trackViewURL = trackViewURL
        self.previewURL = previewURL
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.releaseDate = releaseDate
        self.collectionExplicitness = collectionExplicitness
        self.trackExplicitness = trackExplicitness
        self.discCount = discCount
        self.discNumber = discNumber
        self.trackCount = trackCount
        self.trackNumber = trackNumber
        self.trackTimeMillis = trackTimeMillis
        self.country = country
        self.currency = currency
        self.primaryGenreName = primaryGenreName
        self.isStreamable = isStreamable
        self.collectionArtistName = collectionArtistName
        self.collectionArtistID = collectionArtistID
        self.collectionArtistViewURL = collectionArtistViewURL
    }
    
    func generateBKModel() -> BKSongModel{
        let model = BKSongModel()
        model.wrapperType = self.wrapperType
        model.kind = self.kind
        model.artistID = self.artistID ?? 0
        model.collectionID = self.collectionID ?? 0
        model.trackID = self.trackID ?? 0
        model.artistName = self.artistName
        model.collectionName = self.collectionName
        model.trackName = self.trackName
        model.collectionCensoredName = self.collectionCensoredName
        model.trackCensoredName = self.trackCensoredName
        model.artistViewURL = self.artistViewURL
        model.collectionViewURL = self.collectionViewURL
        model.trackViewURL = self.trackViewURL
        model.previewURL = self.previewURL
        model.artworkUrl30 = self.artworkUrl30
        model.artworkUrl60 = self.artworkUrl60
        model.artworkUrl100 = self.artworkUrl100
        model.collectionPrice = self.collectionPrice ?? 0
        model.trackPrice = self.trackPrice ?? 0
        model.releaseDate = self.releaseDate
        model.collectionExplicitness = self.collectionExplicitness
        model.trackExplicitness = self.trackExplicitness
        model.discCount = discCount ?? 0
        model.discNumber = self.discNumber ?? 0
        model.trackCount = self.trackCount ?? 0
        model.trackNumber = self.trackNumber ?? 0
        model.trackTimeMillis = self.trackTimeMillis ?? 0
        model.country = self.country
        model.currency = self.currency
        model.primaryGenreName = self.primaryGenreName
        model.isStreamable = self.isStreamable ?? false
        model.collectionArtistName = self.collectionArtistName
        model.collectionArtistID = self.collectionArtistID ?? 0
        model.collectionArtistViewURL = self.collectionArtistViewURL
        return model
    }
}

class BKSongModel: Object {
    @objc dynamic var wrapperType: String?
    @objc dynamic var kind: String?
    @objc dynamic var artistID: Int = 0
    @objc dynamic var collectionID: Int = 0
    @objc dynamic var trackID: Int = 0
    @objc dynamic var artistName, collectionName, trackName, collectionCensoredName: String?
    @objc dynamic var trackCensoredName: String?
    @objc dynamic var artistViewURL, collectionViewURL, trackViewURL: String?
    @objc dynamic var previewURL: String?
    @objc dynamic var artworkUrl30, artworkUrl60, artworkUrl100: String?
    @objc dynamic var collectionPrice: Double = 0
    @objc dynamic var trackPrice: Double = 0
    @objc dynamic var releaseDate: String?
    @objc dynamic var collectionExplicitness, trackExplicitness: String?
    @objc dynamic var discCount: Int = 0
    @objc dynamic var discNumber: Int = 0
    @objc dynamic var trackCount: Int = 0
    @objc dynamic var trackNumber: Int = 0
    @objc dynamic var trackTimeMillis: Int = 0
    @objc dynamic var country: String?
    @objc dynamic var currency: String?
    @objc dynamic var primaryGenreName: String?
    @objc dynamic var isStreamable: Bool = false
    @objc dynamic var collectionArtistName: String?
    @objc dynamic var collectionArtistID: Int = 0
    @objc dynamic var collectionArtistViewURL: String?
    
    override static func primaryKey() -> String? {
        return "trackID"
    }
    
    func generateDisplayModel() -> SongModel{
        return SongModel.init(wrapperType: self.wrapperType ?? "",
                                   kind: self.kind ?? "",
                                   artistID: self.artistID,
                                   collectionID: self.collectionID,
                                   trackID: self.trackID,
                                   artistName: self.artistName ?? "",
                                   collectionName: self.collectionName ?? "",
                                   trackName: self.trackName ?? "",
                                   collectionCensoredName: self.collectionCensoredName ?? "",
                                   trackCensoredName: self.trackCensoredName ?? "",
                                   artistViewURL: self.artistViewURL ?? "",
                                   collectionViewURL: self.collectionViewURL ?? "",
                                   trackViewURL: self.trackViewURL ?? "",
                                   previewURL: self.previewURL ?? "",
                                   artworkUrl30: self.artworkUrl30 ?? "",
                                   artworkUrl60: self.artworkUrl60 ?? "",
                                   artworkUrl100: self.artworkUrl100 ?? "",
                                   collectionPrice: self.collectionPrice,
                                   trackPrice: self.trackPrice,
                                   releaseDate: self.releaseDate ?? "",
                                   collectionExplicitness: self.collectionExplicitness ?? "",
                                   trackExplicitness: self.trackExplicitness ?? "",
                                   discCount: discCount,
                                   discNumber: self.discNumber,
                                   trackCount: self.trackCount,
                                   trackNumber: self.trackNumber,
                                   trackTimeMillis: self.trackTimeMillis,
                                   country: self.country ?? "",
                                   currency: self.currency ?? "",
                                   primaryGenreName: self.primaryGenreName ?? "",
                                   isStreamable: self.isStreamable,
                                   collectionArtistName: self.collectionArtistName ?? "",
                                   collectionArtistID: self.collectionArtistID,
                                   collectionArtistViewURL: self.collectionArtistViewURL)
    }
}
