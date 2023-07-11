//
//  MessageStruct.swift
//  MessageBoard
//
//  Created by imac-3570 on 2023/7/11.
//

import Foundation
import RealmSwift

struct MessageStruct {
    
    var id: ObjectId
    
    var messager: String
    
    var message:  String
    
    var timeStamp: Int
}
