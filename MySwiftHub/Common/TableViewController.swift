//
//  TableViewController.swift
//  MySwiftHub
//
//  Created by 黄永乐 on 2018/12/20.
//  Copyright © 2018 黄永乐. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh
import DZNEmptyDataSet
import SnapKit

class TableViewController: UIViewController, UIScrollViewDelegate {
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self as? DZNEmptyDataSetSource
        view.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()
    
    var clearsSelectionOnViewWillAppear = true

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            guard let self = self else {
                return
            }
            if self.tableView.headRefreshControl.isTriggeredRefreshByUser == false {
                self.headerRefreshTrigger.onNext(())
            }
        })
        
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })
        
        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        
        tableView.footRefreshControl.autoRefreshOnFoot = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            deselectSelectedRow()
        }
    }
    
    
    

}

extension TableViewController {
    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach {
                tableView.deselectRow(at: $0, animated: false)
            }
        }
    }
}


extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
}
