//
//  BookMarkVC.swift
//  KeysocCodeTest
//
//  Created by BillBill on 8/10/2023.
//

import UIKit
import RxSwift
import PagingKit

class BookMarkVC: UIViewController {

    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var pagingView: UIView!
    
    let disposeBag = DisposeBag.init()
    let vm = ItunesAPIVM()
    let tabs = ["Songs", "Albums", "Artists"]
    private let pagingMenuVC = PagingMenuViewController.init()
    var getCurrentIndex: Int { get { return self.pagingMenuVC.currentFocusedIndex ?? 0 } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTv()
        self.setupPagingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vm.getDataFromDB()
    }
    
    private func setupPagingView() {
        self.pagingView.addSubview(self.pagingMenuVC.view)
        self.pagingMenuVC.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.pagingMenuVC.register(nib: UINib(nibName: "PagingNormalView", bundle: nil), forCellWithReuseIdentifier: "PagingNormalView")
        self.pagingMenuVC.registerFocusView(nib: UINib.init(nibName: "PagingFocusView", bundle: nil))
        
        self.pagingMenuVC.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.pagingMenuVC.delegate = self
        self.pagingMenuVC.dataSource = self
        self.pagingMenuVC.reloadData()
    }
    
    
    
    private func setupTv() {
        self.tv.register(.init(nibName: "SongSearchResultCell", bundle: nil), forCellReuseIdentifier: "SongSearchResultCell")
        self.tv.register(.init(nibName: "AlbumSearchResultCell", bundle: nil), forCellReuseIdentifier: "AlbumSearchResultCell")
        self.tv.register(.init(nibName: "ArtistSearchResultCell", bundle: nil), forCellReuseIdentifier: "ArtistSearchResultCell")

        self.tv.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.vm.displayList
            .bind(to: self.tv.rx.items, curriedArgument: { tv, row, item -> UITableViewCell in
                return self.vm.getCell(item: item, tv: tv, vc: self)
            }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.vm.songList, self.vm.albumList, self.vm.artistList)
            .subscribe(onNext: { [weak self] songList, albumList, artistList in
                guard let self = self else { return }
                switch self.getCurrentIndex {
                case 0: self.vm.displayList.accept(songList)
                case 1: self.vm.displayList.accept(albumList)
                case 2: self.vm.displayList.accept(artistList)
                default: break
                }
            }).disposed(by: self.disposeBag)
    }

}

extension BookMarkVC: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return self.tabs.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        if let cell = viewController.dequeueReusableCell(withReuseIdentifier: "PagingNormalView", for: index) as? PagingNormalView {
            cell.titleLabel.text = self.tabs[index]
            return cell
        }
        return PagingNormalView.init()
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
}

extension BookMarkVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BookMarkVC: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingKit.PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        switch page {
        case 0:
            self.vm.displayList.accept(self.vm.songList.value)
            self.vm.currentDisplayType = .song
        case 1:
            self.vm.displayList.accept(self.vm.albumList.value)
            self.vm.currentDisplayType = .album
        case 2:
            self.vm.displayList.accept(self.vm.artistList.value)
            self.vm.currentDisplayType = .artist
        default: break
        }
    }
}

extension BookMarkVC: SongSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: SongModel) {
        DBService.shared.deleteData(object: BKSongModel.self, query: {$0.trackID == model.trackID})
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.vm.getDataFromDB()
        })
    }
}

extension BookMarkVC: AlbumSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: AlbumModel) {
        DBService.shared.deleteData(object: BKAlbumModel.self, query: {$0.collectionID == model.collectionID})
        self.vm.getDataFromDB()
    }
}

extension BookMarkVC: ArtistSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: ArtistModel) {
        DBService.shared.deleteData(object: BKArtistModel.self, query: {$0.artistID == model.artistID})
        self.vm.getDataFromDB()
    }
}
