//
//  KafkaRefresh+Rx.swift
//  MySwiftHub
//
//  Created by 黄永乐 on 2018/12/20.
//  Copyright © 2018 黄永乐. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import KafkaRefresh

extension Reactive where Base: KafkaRefreshControl {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}
