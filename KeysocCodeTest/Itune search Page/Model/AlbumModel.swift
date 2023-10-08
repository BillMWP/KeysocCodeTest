import Foundation
import RealmSwift
// MARK: - ArtistList
class AlbumListModel: Codable {
    var resultCount: Int
    var results: [AlbumModel]

    init(resultCount: Int, results: [AlbumModel]) {
        self.resultCount = resultCount
        self.results = results
    }
}

// MARK: - Result
class AlbumModel: Codable {
    var wrapperType: String?
    var collectionType: String?
    var artistID, collectionID: Int?
    var amgArtistID: Int?
    var artistName, collectionName, collectionCensoredName: String?
    var artistViewURL, collectionViewURL: String?
    var artworkUrl60, artworkUrl100: String?
    var collectionPrice: Double?
    var collectionExplicitness: String?
    var trackCount: Int?
    var copyright: String?
    var country: String?
    var currency: String?
    var releaseDate: String?
    var primaryGenreName: String?
    var contentAdvisoryRating: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case collectionID = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName, contentAdvisoryRating
    }

    init(wrapperType: String, collectionType: String, artistID: Int, collectionID: Int, amgArtistID: Int?, artistName: String, collectionName: String, collectionCensoredName: String, artistViewURL: String, collectionViewURL: String, artworkUrl60: String, artworkUrl100: String, collectionPrice: Double, collectionExplicitness: String, trackCount: Int, copyright: String, country: String, currency: String, releaseDate: String, primaryGenreName: String, contentAdvisoryRating: String?) {
        self.wrapperType = wrapperType
        self.collectionType = collectionType
        self.artistID = artistID
        self.collectionID = collectionID
        self.amgArtistID = amgArtistID
        self.artistName = artistName
        self.collectionName = collectionName
        self.collectionCensoredName = collectionCensoredName
        self.artistViewURL = artistViewURL
        self.collectionViewURL = collectionViewURL
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.collectionExplicitness = collectionExplicitness
        self.trackCount = trackCount
        self.copyright = copyright
        self.country = country
        self.currency = currency
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
        self.contentAdvisoryRating = contentAdvisoryRating
    }
    func generateBKModel() -> BKAlbumModel {
        let model = BKAlbumModel()
        model.wrapperType = self.wrapperType
        model.collectionType = self.collectionType
        model.artistID = self.artistID ?? 0
        model.collectionID = self.collectionID ?? 0
        model.amgArtistID = self.amgArtistID ?? 0
        model.artistName = self.artistName
        model.collectionName = self.collectionName
        model.collectionCensoredName = self.collectionCensoredName
        model.artistViewURL = self.artistViewURL
        model.collectionViewURL = self.collectionViewURL
        model.artworkUrl60 = self.artworkUrl60
        model.artworkUrl100 = self.artworkUrl100
        model.collectionPrice = self.collectionPrice ?? 0
        model.collectionExplicitness = self.collectionExplicitness
        model.trackCount = self.trackCount ?? 0
        model.copyright = self.copyright
        model.country = self.country
        model.currency = self.currency
        model.releaseDate = self.releaseDate
        model.primaryGenreName = self.primaryGenreName
        model.contentAdvisoryRating = self.contentAdvisoryRating
        
        return model
    }
}

class BKAlbumModel: Object {
    @objc dynamic var wrapperType: String?
    @objc dynamic var collectionType: String?
    @objc dynamic var artistID: Int = 0
    @objc dynamic var collectionID: Int = 0
    @objc dynamic var amgArtistID: Int = 0
    @objc dynamic var artistName: String?
    @objc dynamic var collectionName: String?
    @objc dynamic var collectionCensoredName: String?
    @objc dynamic var artistViewURL: String?
    @objc dynamic var collectionViewURL: String?
    @objc dynamic var artworkUrl60: String?
    @objc dynamic var artworkUrl100: String?
    @objc dynamic var collectionPrice: Double = 0
    @objc dynamic var collectionExplicitness: String?
    @objc dynamic var trackCount: Int = 0
    @objc dynamic var copyright: String?
    @objc dynamic var country: String?
    @objc dynamic var currency: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var primaryGenreName: String?
    @objc dynamic var contentAdvisoryRating: String?
    
    override class func primaryKey() -> String? {
        return "collectionID"
    }
    
    func generateDisplayModel() -> AlbumModel{
        return AlbumModel(wrapperType: self.wrapperType ?? "",
                          collectionType: self.collectionType ?? "",
                          artistID: self.artistID,
                          collectionID: self.collectionID,
                          amgArtistID: self.amgArtistID,
                          artistName: self.artistName ?? "",
                          collectionName: self.collectionName ?? "",
                          collectionCensoredName: self.collectionCensoredName ?? "",
                          artistViewURL: self.artistViewURL ?? "",
                          collectionViewURL: self.collectionViewURL ?? "",
                          artworkUrl60: self.artworkUrl60 ?? "",
                          artworkUrl100: self.artworkUrl100 ?? "",
                          collectionPrice: self.collectionPrice,
                          collectionExplicitness: self.collectionExplicitness ?? "",
                          trackCount: self.trackCount,
                          copyright: self.copyright ?? "",
                          country: self.country ?? "",
                          currency: self.currency ?? "",
                          releaseDate: self.releaseDate ?? "",
                          primaryGenreName: self.primaryGenreName ?? "",
                          contentAdvisoryRating: self.contentAdvisoryRating ?? "")
    }
}
