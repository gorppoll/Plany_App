//
//  FriendRequestCell.swift
//  inviti
//
//  Created by Gop on 10/11/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var statusTextField: UILabel!

    @IBOutlet weak var imageRequest: UIImageView!
    
    @IBOutlet weak var userNameRequest: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusTextField.alpha = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
