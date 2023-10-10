//
//  ItuneSearchVC.swift
//  KeysocCodeTest
//
//  Created by BillBill on 7/10/2023.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import PagingKit
import SnapKit


class ItuneSearchVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tv: UITableView!
    
    
    let vm = ItunesAPIVM()
    let disposeBag = DisposeBag.init()
    var pendingRequestWorkItem: DispatchWorkItem?
    private let pagingMenuVC = PagingMenuViewController.init()
    var getCurrentIndex: Int { get { return self.pagingMenuVC.currentFocusedIndex ?? 0 } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTv()
        self.setupSearchBar()
        self.setupPagingView()
//        let models = DBService.shared.getData(object: BKSongModel.self)
//        models.forEach({print("--m", $0.trackName)})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ItunesAPIVM.test {
            self.vm.displayList.accept(self.vm.displayList.value)
            ItunesAPIVM.test.toggle()
        }
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
                switch self.vm.currentDisplayType {
                case .song: self.vm.displayList.accept(songList)
                case .album: self.vm.displayList.accept(albumList)
                case .artist: self.vm.displayList.accept(artistList)
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupPagingView() {
        self.tabBarView.addSubview(self.pagingMenuVC.view)
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
    
    private func setupSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.rx.text
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.pendingRequestWorkItem?.cancel()
                guard let text = text else { return }
                self.pendingRequestWorkItem = DispatchWorkItem.init(block: {
                    if text.isEmpty {
                        self.vm.songList.accept([])
                        self.vm.albumList.accept([])
                        self.vm.artistList.accept([])
                    } else {
                        self.vm.fetchData(searchKeyWotd: text, purpose: .initial, entity: .song)
                        self.vm.fetchData(searchKeyWotd: text, purpose: .initial, entity: .album)
                        self.vm.fetchData(searchKeyWotd: text, purpose: .initial, entity: .artist)
                    }
                })
                
                self.tv.contentOffset = .zero
                if let pendingRequestWorkItem = self.pendingRequestWorkItem { DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: pendingRequestWorkItem)
                }
            }).disposed(by: self.disposeBag)
    }
}

// MARK: tableview delegate
extension ItuneSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.vm.displayList.value.count - 3 && self.vm.getPageInfo().shouldLoadMore {
            self.vm.fetchData(searchKeyWotd: self.searchBar.text ?? "",
                              purpose: .loadmore,
                              entity: self.vm.currentDisplayType)
        }
    }
    
}

// MARK: Paging Tab delegate
extension ItuneSearchVC: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingKit.PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        let currentEntity = SearchEntity.getEntityWithPage(page: page)
        self.vm.currentDisplayType = currentEntity
        switch currentEntity {
        case .song:
            self.vm.displayList.accept(self.vm.songList.value)
        case .album:
            self.vm.displayList.accept(self.vm.albumList.value)
        case .artist:
            self.vm.displayList.accept(self.vm.artistList.value)
        }
    }
}

extension ItuneSearchVC: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return self.vm.tabs.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        if let cell = viewController.dequeueReusableCell(withReuseIdentifier: "PagingNormalView", for: index) as? PagingNormalView {
            cell.titleLabel.text = self.vm.tabs[index]
            return cell
        }
        return PagingNormalView.init()
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
}

// MARK: 3 type of cell's delegate
extension ItuneSearchVC: SongSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: SongModel) {
        bookmark ? DBService.shared.addData(model: model.generateBKModel()) : DBService.shared.deleteData(object: BKSongModel.self, query: {$0.trackID == model.trackID})
    }
}

extension ItuneSearchVC: AlbumSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: AlbumModel) {
        bookmark ? DBService.shared.addData(model: model.generateBKModel()) : DBService.shared.deleteData(object: BKAlbumModel.self, query: {$0.collectionID == model.collectionID})
    }
}

extension ItuneSearchVC: ArtistSearchResultCellDelegate {
    func bookmarkDidClick(bookmark: Bool, model: ArtistModel) {
        bookmark ? DBService.shared.addData(model: model.generateBKModel()) : DBService.shared.deleteData(object: BKArtistModel.self, query: {$0.artistID == model.artistID})
    }
}
