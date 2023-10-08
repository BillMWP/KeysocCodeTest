//
//  AlbumSearchResultCell.swift
//  KeysocCodeTest
//
//  Created by BillBill on 8/10/2023.
//

import UIKit
import RxSwift
import RxRelay

protocol AlbumSearchResultCellDelegate: NSObjectProtocol {
    func bookmarkDidClick(bookmark: Bool, model: AlbumModel)
}

extension AlbumSearchResultCellDelegate  {
    func bookmarkDidClick(bookmark: Bool, model: AlbumModel) {}
}

class AlbumSearchResultCell: UITableViewCell {

    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    var bookMarked: BehaviorRelay<Bool> = .init(value: false)
    let disposeBag = DisposeBag.init()
    var model: AlbumModel? = nil
    weak var delegate: AlbumSearchResultCellDelegate?
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
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupUI() {
        self.albumName.font = .systemFont(ofSize: 16)
        self.artistName.font = .systemFont(ofSize: 14)
        self.artistName.textColor = .gray
        self.bookmarkBtn.titleLabel?.isHidden = true
    }
    
    func setCOntent(model: AlbumModel) {
        self.model = model
        self.albumName.text = model.collectionName ?? ""
        self.artistName.text  = model.artistName ?? ""
        
        if let url = URL(string: model.artworkUrl100 ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: ", error)
                    return
                }
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self.albumImage.image = UIImage(data: data)
                }
            }.resume()
        }
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
