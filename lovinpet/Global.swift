//
//  Global.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Global {
    static let sharedInstance = Global()
    
    private init() {
        
    }
    
    var user: User!
    
    var avatar = ""
    var nickname = ""
    var age = ""
    var breed = ""
    var gender = ""
}

