//
//  RealmStruct.swift
//  MessageBoard
//
//  Created by imac-3570 on 2023/7/9.
//

import Foundation
import RealmSwift

class Message: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var messager: String = ""
    @Persisted var message: String = ""
    @Persisted var timeStamp: Int
    
    convenience init(messager: String, message: String, timeStamp: Int) {
        self.init()
        self.messager = messager
        self.message = message
        self.timeStamp = timeStamp
    }
}
