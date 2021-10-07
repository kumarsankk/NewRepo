//
//  UserModel.swift
//  DataEntrySample
//
//  Created by Admin on 06/10/21.
//

import Foundation
import RealmSwift

class User_Node : Object {
    
    @objc dynamic var id :String = ""
    @objc dynamic var firstname : String = ""
    @objc dynamic var lastname : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var phonenumber : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var password : String = ""
    let children = List<String>()
    @objc dynamic var parent_id:String = ""
    
    override static func primaryKey() -> String{
        return "id";
    }
}

struct User {
    var U_Id :String = ""
    var U_Firstname : String = ""
    var U_Lastname : String = ""
    var U_Email : String = ""
    var U_Phonenumber : String = ""
    var U_Gender : String = ""
    var U_Password : String = ""
    
    init() {
        U_Id = ""
        U_Firstname = ""
        U_Lastname = ""
        U_Email = ""
        U_Phonenumber = ""
        U_Gender = ""
        U_Password = ""
    }
    
    init(id: String, fname: String, lname: String, email: String, phone: String, gender: String, password: String) {
        U_Id = id
        U_Firstname = fname
        U_Lastname = lname
        U_Email = email
        U_Phonenumber = phone
        U_Gender = gender
        U_Password = password
    }
    init(fname: String, lname: String, email: String, phone: String, gender: String, password: String) {
        U_Firstname = fname
        U_Lastname = lname
        U_Email = email
        U_Phonenumber = phone
        U_Gender = gender
        U_Password = password
    }
    init(id: String, fname: String, lname: String, email: String, phone: String, gender: String) {
        U_Id = id
        U_Firstname = fname
        U_Lastname = lname
        U_Email = email
        U_Phonenumber = phone
        U_Gender = gender
        U_Password = "password"
    }
}
class UserModel {
    public static let sharedInstance = UserModel()
    var registartionList = [User]()
    var creatingUserObject: User?
    func getAllRegistrationsFromDB(callBack: @escaping (APP_RET_VAL) -> Void) {
        let nodes = UserRealmDb.instance.fetchAllNodesFromRealm()
        if nodes.count > 0 {
            self.registartionList.removeAll()
            for node in nodes {
                let userObj = User(id: node.id, fname: node.firstname, lname: node.lastname, email: node.email, phone: node.phonenumber, gender: node.gender)
                self.registartionList.append(userObj)
            }
            callBack(APP_RET_VAL.RET_SUCCESS)
        }else {
            callBack(APP_RET_VAL.RET_ERROR)
        }
    }
    func setCreatingUserObject(f_name: String, l_name: String, Email: String, Password: String, Gender: String, Phone: String) {
        self.creatingUserObject = User(fname: f_name, lname: l_name, email: Email, phone: Phone, gender: Gender, password: Password)
    }
    func createUserNodeInDB(callBack: @escaping (APP_RET_VAL) -> Void) {
        if self.creatingUserObject != nil {
            UserRealmDb.instance.createNode(userObj: self.creatingUserObject!) { (result) in
                if result == APP_RET_VAL.RET_SUCCESS {
                    callBack(APP_RET_VAL.RET_SUCCESS)
                }else {
                    callBack(APP_RET_VAL.RET_ERROR)
                }
            }
        }else {
            callBack(APP_RET_VAL.RET_ERROR)
        }
    }
}
class UserRealmDb {
    public static let instance = UserRealmDb()
    func createNode(userObj: User, callBack: @escaping (APP_RET_VAL) -> Void) {
//        let realm = try! Realm()
//        try! realm.write {
//            let usernode = User_Node()
//            usernode.firstname = userObj.U_Firstname
//            usernode.lastname = userObj.U_Lastname
//            usernode.email = userObj.U_Email
//            usernode.phonenumber = userObj.U_Phonenumber
//            usernode.password = userObj.U_Password
//            usernode.gender = userObj.U_Gender
//            realm.add(usernode)
//        }
        do {
            let realm = try Realm()
            realm.beginWrite()
            let usernode = User_Node()
            usernode.firstname = userObj.U_Firstname
            usernode.lastname = userObj.U_Lastname
            usernode.email = userObj.U_Email
            usernode.phonenumber = userObj.U_Phonenumber
            usernode.password = userObj.U_Password
            usernode.gender = userObj.U_Gender
            realm.add(usernode)
            try realm.commitWrite()
            callBack(APP_RET_VAL.RET_SUCCESS)
        }
        catch{
            callBack(APP_RET_VAL.RET_ERROR)
        }
    }
    //func to fetch nodes
    func fetchAllNodesFromRealm() -> Results<User_Node> {
        let realm = try! Realm()
        let nodes = realm.objects(User_Node.self)
        return nodes as Results<User_Node>
    }
    //func to fetch nodes based on an id
    func fetchNodesFromRealm(property:String, value:String) -> Results<User_Node> {
        let realm = try! Realm()
        print("cgds : "+("\(property)=\'\(value)'"))
        let nodes = realm.objects(User_Node.self).filter("\(property)=\'\(value)'")
        return nodes as Results<User_Node>
    }
    
    func fetchNodeFromRealm(property:String, value:Int) -> User_Node? {
        let realm = try! Realm()
        let node = realm.objects(User_Node.self).filter("\(property)=\(value)").first
        return node
    }
    
    //func to fetch nodes based on a property
    func fetchNodesFromRealmforProperty(property:String,value:String) -> Results<User_Node> {
        let realm = try! Realm()
        let nodes = realm.objects(User_Node.self).filter("\(property)=\'\(value)'")
        return nodes as Results<User_Node>
    }
    
    func deleteRealmDbObjects(){
        self.clearCurrentLocalDb()
    }
    //func to delete the realm db..
    func removeRealmDb(){
        try!
            FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private func clearCurrentLocalDb() {
        let realm = try! Realm()
        if !realm.isEmpty {
            realm.deleteAll()
        }
    }
    
    //func to delete a node
    private func deleteNodeFromRealm(id:String){
        let realm = try! Realm()
        let node = fetchNodesFromRealm(property: "id", value: id)
        try? realm.write ({
            realm.delete(node)
        })
    }
}

public enum APP_RET_VAL {
    case RET_SUCCESS
    case RET_ERROR
}
