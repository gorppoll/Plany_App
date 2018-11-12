//
//  CustomCellMain.swift
//  inviti
//
//  Created by Gop on 10/6/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import UIKit

class CustomCellMain: UITableViewCell {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
        
        cellBackground.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
