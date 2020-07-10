//
//  DetailTableViewCell.swift
//  finerio-test
//
//  Created by Macintosh HD on 09/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var movementDetail: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
