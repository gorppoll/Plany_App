//
//  friendTableViewCell.swift
//  CalendarForInviti
//
//  Created by Gop on 10/13/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit

class friendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
