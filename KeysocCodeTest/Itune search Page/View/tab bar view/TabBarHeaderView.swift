//
//  TabBarHeaderView.swift
//  KeysocCodeTest
//
//  Created by BillBill on 7/10/2023.
//

import UIKit
import PagingKit
class TabBarHeaderView: UITableViewHeaderFooterView {
    
    private let pagingMenuVC = PagingMenuViewController.init()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupPagingView()
 
    }
    
    private func setupPagingView() {
        self.addSubview(self.pagingMenuVC.view)
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

}

extension TabBarHeaderView: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingKit.PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        print("--m", page)
    }
}

extension TabBarHeaderView: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return 3
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        if let cell = viewController.dequeueReusableCell(withReuseIdentifier: "PagingNormalView", for: index) as? PagingNormalView {
            cell.titleLabel.text = "testLabel"
            return cell
        }
        return PagingNormalView.init()
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return 80.0
    }
}

