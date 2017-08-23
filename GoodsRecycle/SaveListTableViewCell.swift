//
//  SaveListTableViewCell.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/23.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class SaveListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgSave: UIImageView!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgSave.layer.cornerRadius = 10
        self.imgSave.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
