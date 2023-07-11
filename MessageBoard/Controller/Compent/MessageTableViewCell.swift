//
//  MessageTableViewCell.swift
//  MessageBoard
//
//  Created by imac-3570 on 2023/7/9.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messagerLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    let timeStamp: Int? = nil
    
    static let identified = "MessageTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
