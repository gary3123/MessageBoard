//
//  Alert.swift
//  MessageBoard
//
//  Created by imac-3570 on 2023/7/10.
//

import Foundation
import UIKit

class Alert {
    static func showActionSheet(cancelTitle: String,
                                vc: UIViewController,
                                newToOldConfirmTitle: String,
                                oldToNewConfirmTitle: String,
                                newToOldConfirm: (() -> Void)? = nil,
                                oldToNewConfirm: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
            let newToOldAction = UIAlertAction(title: newToOldConfirmTitle, style: .default) { _ in
                newToOldConfirm?()
            }
            
            let oldToNewAction = UIAlertAction(title: oldToNewConfirmTitle, style: .default) { _ in
                oldToNewConfirm?()
            }
            
            alertController.addAction(newToOldAction)
            alertController.addAction(oldToNewAction)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alertController.addAction(cancelAction)
            vc.present(alertController,animated: true)
        }
    }
}
