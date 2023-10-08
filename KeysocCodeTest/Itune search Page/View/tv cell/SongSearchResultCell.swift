//
//  SongSearchResultCell.swift
//  KeysocCodeTest
//
//  Created by BillBill on 8/10/2023.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

protocol SongSearchResultCellDelegate: NSObjectProtocol {
    func bookmarkDidClick(bookmark: Bool, model: SongModel)
}

extension SongSearchResultCellDelegate  {
    func bookmarkDidClick(bookmark: Bool, model: SongModel) {}
}

class SongSearchResultCell: UITableViewCell {
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var songType: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    var bookMarked: BehaviorRelay<Bool> = .init(value: false)
    let disposeBag = DisposeBag.init()
    var model: SongModel? = nil
    weak var delegate: SongSearchResultCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupRx()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupUI() {
        self.trackName.textColor = .black
        self.trackName.font = .systemFont(ofSize: 16)
        
        self.songType.font = .systemFont(ofSize: 14)
        self.songType.textColor = .gray
        
        self.bookmarkBtn.titleLabel?.isHidden = true
    }
    
    private func setupRx() {
        self.bookMarked.subscribe(onNext: {[weak self]  bookmarked in
            guard let self = self else { return }
            self.bookmarkBtn.setImage(.init(named: bookmarked ? "bookmark_fill" : "bookmark"), for: .normal)
        }).disposed(by: self.disposeBag)
    }
    
    func setContent(model: SongModel) {
        self.model = model
        self.trackName.text = model.trackName
        self.songType.text = model.primaryGenreName
        
        if let url = URL(string: model.artworkUrl60 ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: ", error)
                    return
                }
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self.songImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @IBAction func bookmarkClicked(_ sender: Any) {
        guard let model = model else { return }
        self.bookMarked.accept(!self.bookMarked.value)
        self.delegate?.bookmarkDidClick(bookmark: self.bookMarked.value, model: model)
    }
    
    
}
