import Foundation
import RealmSwift

class ArtistListModel: Codable {
    var resultCount: Int?
    var results: [ArtistModel] = []

    init(resultCount: Int, results: [ArtistModel]) {
        self.resultCount = resultCount
        self.results = results
    }
}

// MARK: - Result
class ArtistModel: Codable {
    var wrapperType: String?
    var artistType: String?
    var artistName: String?
    var artistLinkURL: String?
    var artistID: Int?
    var amgArtistID: Int?
    var primaryGenreName: String?
    var primaryGenreID: Int?

    enum CodingKeys: String, CodingKey {
        case wrapperType, artistType, artistName
        case artistLinkURL = "artistLinkUrl"
        case artistID = "artistId"
        case amgArtistID = "amgArtistId"
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
    }

    init(wrapperType: String, artistType: String, artistName: String, artistLinkURL: String, artistID: Int, amgArtistID: Int?, primaryGenreName: String?, primaryGenreID: Int?) {
        self.wrapperType = wrapperType
        self.artistType = artistType
        self.artistName = artistName
        self.artistLinkURL = artistLinkURL
        self.artistID = artistID
        self.amgArtistID = amgArtistID
        self.primaryGenreName = primaryGenreName
        self.primaryGenreID = primaryGenreID
    }
    
    func generateBKModel() -> BKArtistModel {
        let model = BKArtistModel()
        model.wrapperType = self.wrapperType
        model.artistType = self.artistType
        model.artistName = self.artistName
        model.artistLinkURL = self.artistLinkURL
        model.artistID = self.artistID ?? 0
        model.amgArtistID = self.amgArtistID ?? 0
        model.primaryGenreName = self.primaryGenreName
        model.primaryGenreID = self.primaryGenreID ??  0
        return model
    }
}

class BKArtistModel: Object {
    @objc dynamic var wrapperType: String?
    @objc dynamic var artistType: String?
    @objc dynamic var artistName: String?
    @objc dynamic var artistLinkURL: String?
    @objc dynamic var artistID: Int = 0
    @objc dynamic var amgArtistID: Int = 0
    @objc dynamic var primaryGenreName: String?
    @objc dynamic var primaryGenreID: Int = 0
    
    override class func primaryKey() -> String? {
        return "artistID"
    }
    
    func generateDisplayModel() -> ArtistModel {
        return ArtistModel(wrapperType: self.wrapperType ?? "",
                           artistType: self.artistType ?? "",
                           artistName: self.artistName ?? "",
                           artistLinkURL: self.artistLinkURL ?? "",
                           artistID: self.artistID,
                           amgArtistID: self.amgArtistID,
                           primaryGenreName: self.primaryGenreName ?? "",
                           primaryGenreID: self.primaryGenreID)
    }
}

