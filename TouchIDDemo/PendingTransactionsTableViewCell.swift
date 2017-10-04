//
//  PendingTransactionsTableViewCell.swift
//  TouchIDDemo
//
//  Created by Iva on 20/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit

class PendingTransactionsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var index: Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
