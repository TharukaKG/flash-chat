//
//  SenderTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by TharukaCs on 2022-07-26.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var avatar: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
