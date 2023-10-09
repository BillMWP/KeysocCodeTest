//
//  ItuneSearchVM.swift
//  KeysocCodeTest
//
//  Created by BillBill on 7/10/2023.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
// MARK: two vc share same vm
enum SearchEntity: String {
    case song = "song", album = "album", artist = "allArtist"
}
enum FetchPurpose {
    case initial, loadmore
}

class ItunesAPIVM: NSObject {
    typealias PageLoadingInfo = (page: Int, shouldLoadMore: Bool)
    // for store data for 3 tabs
    var songPageInfo:PageLoadingInfo = (1, true)
    var albumPageInfo:PageLoadingInfo = (1, true)
    var artistPageInfo:PageLoadingInfo = (1, true)
    let fixPageSize: Int = 20
    let tabs = ["Songs".localized, "Albums".localized, "Artists".localized]
    
    // for display
    var displayList: BehaviorRelay<[AnyObject]> = .init(value: [])
    var currentDisplayType: SearchEntity = .song
    
    var songList: BehaviorRelay<[AnyObject]> = .init(value: [])
    var albumList: BehaviorRelay<[AnyObject]> = .init(value: [])
    var artistList: BehaviorRelay<[AnyObject]> = .init(value: [])
    
    func fetchData(searchKeyWotd: String = "", purpose: FetchPurpose, entity: SearchEntity) {
        var targetPage = 1
        // select target page num
        switch entity {
        case .song:
            self.songPageInfo.page = purpose == .initial ? 1 : self.songPageInfo.page + 1
            targetPage = self.songPageInfo.page
        case .album:
            self.albumPageInfo.page = purpose == .initial ? 1 : self.albumPageInfo.page + 1
            targetPage = self.albumPageInfo.page
        case .artist:
            self.artistPageInfo.page = purpose == .initial ? 1 : self.artistPageInfo.page + 1
            targetPage = self.artistPageInfo.page
        }
        
        // construct api url
        let keys = searchKeyWotd.split(separator: " ")
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(keys.joined(separator: "+"))&entity=\(entity.rawValue)&limit=\(targetPage * self.fixPageSize)") else { return }
        print("fetch info: ", searchKeyWotd, entity.rawValue)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("fetch error: ", error)
            } else if let data = data {
                do {
                    switch entity {
                    case .song:
                        let result = try JSONDecoder().decode(SongListModel.self, from: data).results.map({$0 as AnyObject})
                        if (purpose == .loadmore && result.count > self.songList.value.count) ||
                            (purpose == .initial){ self.songList.accept(result) }
                        else { self.songPageInfo.shouldLoadMore = false}
                    case .artist:
                        let result = try JSONDecoder().decode(ArtistListModel.self, from: data).results.map({$0 as AnyObject})
                        if (purpose == .loadmore && result.count > self.artistList.value.count) ||
                            (purpose == .initial){ self.artistList.accept(result) }
                        else { self.artistPageInfo.shouldLoadMore = false}
                    case .album:
                        let result = try JSONDecoder().decode(AlbumListModel.self, from: data).results.map({$0 as AnyObject})
                        if (purpose == .loadmore && result.count > self.albumList.value.count) ||
                            (purpose == .initial){ self.albumList.accept(result) }
                        else { self.albumPageInfo.shouldLoadMore = false}
                    }
                } catch {
                    print("--m url", url.absoluteString)
                    print("--m data", String(decoding: data, as: UTF8.self) )
                    print("\(entity.rawValue) decode error: ", error)
                }
            }
        }.resume()
    }
    
    func getCell(item: AnyObject, tv: UITableView, vc: UIViewController) -> UITableViewCell{
        // define which type of table view cell
        if let item = item as? SongModel, self.currentDisplayType == .song {
            let cell = tv.dequeueReusableCell(withIdentifier: "SongSearchResultCell") as? SongSearchResultCell
            cell?.bookMarked.accept(self.checkBookMarked(model: item, entity: .song))
            cell?.delegate = vc as? SongSearchResultCellDelegate
            cell?.setContent(model: item)
            return cell!
        } else if let item = item as? AlbumModel, self.currentDisplayType == .album {
            let cell = tv.dequeueReusableCell(withIdentifier: "AlbumSearchResultCell") as? AlbumSearchResultCell
            cell?.bookMarked.accept(self.checkBookMarked(model: item, entity: .album))
            cell?.delegate = vc as? AlbumSearchResultCellDelegate
            cell?.setCOntent(model: item)
            return cell!
        } else if let item = item as? ArtistModel, self.currentDisplayType == .artist {
            let cell = tv.dequeueReusableCell(withIdentifier: "ArtistSearchResultCell") as? ArtistSearchResultCell
            cell?.bookMarked.accept(self.checkBookMarked(model: item, entity: .artist))
            cell?.setContent(model: item)
            cell?.delegate = vc as? ArtistSearchResultCellDelegate
            return cell!
        }
        return UITableViewCell()
    }
    
    func getPageInfo() -> PageLoadingInfo {
        switch self.currentDisplayType {
        case .song: return self.songPageInfo
        case .album: return self.albumPageInfo
        case .artist: return self.artistPageInfo
        }
    }
    
    func getDataFromDB() {
        self.songList.accept(Array(DBService.shared.getData(object: BKSongModel.self)).map({$0.generateDisplayModel()}))
        self.albumList.accept(Array(DBService.shared.getData(object: BKAlbumModel.self)).map({$0.generateDisplayModel()}))
        self.artistList.accept(Array(DBService.shared.getData(object: BKArtistModel.self)).map({$0.generateDisplayModel()}))
    }
    
    func checkBookMarked(model: AnyObject?, entity: SearchEntity) -> Bool {
        switch entity {
        case .song:
            guard let model = model as? SongModel else { return false}
            return Array(DBService.shared.getData(object: BKSongModel.self)).contains(where: {$0.trackID == model.trackID})
        case .album:
            guard let model = model as? AlbumModel else { return false}
            return Array(DBService.shared.getData(object: BKAlbumModel.self)).contains(where: {$0.collectionID == model.collectionID})
        case .artist:
            guard let model = model as? ArtistModel else { return false}
            return Array(DBService.shared.getData(object: BKArtistModel.self)).contains(where: {$0.artistID == model.artistID})
        }
    }
}

extension String {
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: "", table: nil)
    }
}
