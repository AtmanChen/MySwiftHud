//
//  Navigator.swift
//  MySwiftHub
//
//  Created by 黄永乐 on 2018/12/20.
//  Copyright © 2018 黄永乐. All rights reserved.
//

import Foundation


protocol Navigatable {
    var navigator: Navigator! { get set }
}


class Navigator {
    
    static var `default` = Navigator()
    
    
    
}
