//
//  RegisteredAccountTableViewCell.swift
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit

class RegisteredAccountTableViewCell: UITableViewCell {

    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Properties
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var environment: UILabel!
    
    
//    @IBAction func loginButtonClicked(_ sender: UIButton) {
//        AuthenticateDevice.sharedInstance.authenticate(registration: ValidRegistrations.registrations[index])
//    }
    
    
}
