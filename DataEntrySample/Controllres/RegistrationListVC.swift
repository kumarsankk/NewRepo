//
//  RegistrationListVC.swift
//  DataEntrySample
//
//  Created by Admin on 06/10/21.
//

import UIKit

class RegistrationListVC: UIViewController {

    @IBOutlet weak var registartionListTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registartionListTable.backgroundColor = .clear
        registartionListTable.register(UINib(nibName: "RegisterListCell", bundle: nil), forCellReuseIdentifier: "RegisterListCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getRegistrationList()
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func registrationAction(_ sender: UIButton) {
        goToViewController(identifier: "RegisterVC")
    }
    func goToViewController(identifier: String) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = Storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    func getRegistrationList() {
        UserModel.sharedInstance.getAllRegistrationsFromDB { (result) in
            if result == APP_RET_VAL.RET_SUCCESS {
                self.registartionListTable.reloadData()
            }else {
                self.showToast(message: "No user data in DB", font: .systemFont(ofSize: 11))
            }
        }
    }
}
extension RegistrationListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserModel.sharedInstance.registartionList.count > 0 {
            return UserModel.sharedInstance.registartionList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterListCell", for: indexPath) as! RegisterListCell
        if UserModel.sharedInstance.registartionList.count > 0 {
            cell.updateCell(object: UserModel.sharedInstance.registartionList[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
