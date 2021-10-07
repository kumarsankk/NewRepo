//
//  RegisterListCell.swift
//  DataEntrySample
//
//  Created by Admin on 06/10/21.
//

import Foundation
import UIKit

class RegisterListCell: UITableViewCell {
    
    @IBOutlet weak var fname: UILabel!
    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateCell(object: User) {
        fname.text = object.U_Firstname
        lname.text = object.U_Lastname
        email.text = object.U_Email
        phone.text = object.U_Phonenumber
        gender.text = object.U_Gender
    }
}
