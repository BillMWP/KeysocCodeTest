//
//  ArtistSearchResultCell.swift
//  KeysocCodeTest
//
//  Created by BillBill on 8/10/2023.
//

import UIKit
import RxSwift
import RxRelay

protocol ArtistSearchResultCellDelegate: NSObjectProtocol {
    func bookmarkDidClick(bookmark: Bool, model: ArtistModel)
}

extension ArtistSearchResultCellDelegate  {
    func bookmarkDidClick(bookmark: Bool, model: ArtistModel) {}
}

class ArtistSearchResultCell: UITableViewCell {

    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var artistName: UILabel!
    var bookMarked: BehaviorRelay<Bool> = .init(value: false)
    let disposeBag = DisposeBag.init()
    var model: ArtistModel? = nil
    weak var delegate: ArtistSearchResultCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupRx()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    private func setupUI() {
        self.artistName.textColor = .black
        self.artistName.font = .systemFont(ofSize: 20)
        self.bookmarkBtn.titleLabel?.isHidden = true
    }
    
    func setContent(model: ArtistModel) {
        self.model = model
        self.artistName.text = model.artistName ?? ""
    }
    private func setupRx() {
        self.bookMarked.subscribe(onNext: {[weak self]  bookmarked in
            guard let self = self else { return }
            self.bookmarkBtn.setImage(.init(named: bookmarked ? "bookmark_fill" : "bookmark"), for: .normal)
        }).disposed(by: self.disposeBag)
    }
    
    
    @IBAction func bookmarkClicked(_ sender: Any) {
        guard let model = self.model else { return }
        self.bookMarked.accept(!self.bookMarked.value)
        self.delegate?.bookmarkDidClick(bookmark: self.bookMarked.value, model: model)
    }
    
}
