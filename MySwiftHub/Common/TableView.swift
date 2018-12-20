//
//  TableView.swift
//  MySwiftHub
//
//  Created by 黄永乐 on 2018/12/20.
//  Copyright © 2018 黄永乐. All rights reserved.
//

import UIKit
import NSObject_Rx

class TableView: UITableView {

    init() {
        super.init(frame: .init(), style: .grouped)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        sectionHeaderHeight = 40
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        tableHeaderView =
        tableFooterView = UIView()
        
        themeService.rx
            .bind({ $0.separatorColor }, to: rx.separatorColor)
            .disposed(by: rx.disposeBag)
        
    }
    
}
