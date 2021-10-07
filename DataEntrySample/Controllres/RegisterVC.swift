//
//  RegisterVC.swift
//  DataEntrySample
//
//  Created by Admin on 06/10/21.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var lastName: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Enter Last Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            lastName.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var firstName: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Enter First Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            firstName.attributedPlaceholder = placeholderText
        }
    }
    
    @IBOutlet weak var email: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Enter E-mail",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            email.attributedPlaceholder = placeholderText
        }
    }
    
    @IBOutlet weak var phoneNumber: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Enter Phone Number",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            phoneNumber.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var confirmPassword: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Confirm Password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            confirmPassword.attributedPlaceholder = placeholderText
        }
    }
    @IBOutlet weak var password: UITextField!{
        didSet {
            let placeholderText = NSAttributedString(string: "Enter Password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            password.attributedPlaceholder = placeholderText
        }
    }
    var genderString: String = ""
    
    @IBOutlet weak var maleRadioButton: UIButton!
    @IBOutlet weak var femaleRadioButton: UIButton!
    @IBOutlet weak var otherRadioButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        phoneNumber.delegate = self
        confirmPassword.delegate = self
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func registerAction(_ sender: UIButton) {
        if checkAllFieldsFilled() {
            registerNewUser()
        }else {
            self.showToast(message: "Please fill all fields", font: .systemFont(ofSize: 12))
        }
    }
    @IBAction func checkButtonAction (_ sender: UIButton) {
        if sender.tag == 111 {
            femaleRadioButton.isSelected = false
            femaleRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            otherRadioButton.isSelected = false
            otherRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            maleRadioButton.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            genderString = "Male"
        }else if sender.tag == 112 {
            maleRadioButton.isSelected = false
            maleRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            otherRadioButton.isSelected = false
            otherRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            femaleRadioButton.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            genderString = "Female"
        }else {
            femaleRadioButton.isSelected = false
            femaleRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            maleRadioButton.isSelected = false
            maleRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            otherRadioButton.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            genderString = "Other"
        }
        
    }
    func registerNewUser() {
        UserModel.sharedInstance.setCreatingUserObject(f_name: firstName.text!, l_name: lastName.text!, Email: email.text!, Password: password.text!, Gender: genderString, Phone: phoneNumber.text!)
        UserModel.sharedInstance.createUserNodeInDB { (result) in
            if result == APP_RET_VAL.RET_SUCCESS {
                self.showToast(message: "Added new user in DB", font: .systemFont(ofSize: 11))
                self.navigationController?.popViewController(animated: true)
            }else {
                self.showToast(message: "Error adding details in DB", font: .systemFont(ofSize: 11))
            }
        }
    }
    func checkAllFieldsFilled() -> Bool {
        var returnValue = false
        if (lastName.text != "" && firstName.text != "") && (email.text != "" && phoneNumber.text != "") && (password.text != "" && confirmPassword.text != "") && genderString != "" {
            returnValue = true
        }else {
            returnValue = false
        }
        return returnValue
    }
}
extension RegisterVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 114:
            if textField.text?.count == 10 {
                phoneNumber.text = textField.text
            }else {
                phoneNumber.text = ""
                self.showToast(message: "Please enter valid number", font: .systemFont(ofSize: 11))
            }
        case 115:
            if textField.text == password.text {
                confirmPassword.text = textField.text
            }else {
                confirmPassword.text = ""
                self.showToast(message: "Password must be same", font: .systemFont(ofSize: 11))
            }
        case 117:
            if validate(emailAddress: textField.text!){
                email.text = textField.text
            }else {
                email.text = ""
                self.showToast(message: "enter valid email", font: .systemFont(ofSize: 11))
            }
        default:
            break
        }
    }
    func validate(emailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
    }
}
