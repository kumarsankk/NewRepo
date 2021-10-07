//
//  HomeVC.swift
//  DataEntrySample
//
//  Created by Admin on 06/10/21.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func registerAction(_ sender: UIButton) {
        goToViewController(identifier: "RegisterVC")
    }
    @IBAction func registrationAction(_ sender: UIButton) {
        goToViewController(identifier: "RegistrationListVC")
    }
    func goToViewController(identifier: String) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = Storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(ViewController, animated: true)
    }

}
