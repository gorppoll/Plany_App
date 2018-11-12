//
//  CustomCellMainSide.swift
//  inviti
//
//  Created by Gop on 10/7/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit

class CustomCellMainSide: UITableViewCell {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Time: UILabel!
   
    @IBOutlet weak var Sender: UILabel!
    
    @IBOutlet weak var Place: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var sended: UIView!
    
    @IBOutlet weak var notification: UIView!
    
    @IBOutlet weak var cellBackground: UIView!
    
    @IBOutlet weak var read: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        notification.layer.cornerRadius = 12
        notification.alpha = 0
        
        sended.alpha = 0
        
        cellBackground.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
