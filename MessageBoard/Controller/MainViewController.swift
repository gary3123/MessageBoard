//
//  MainViewController.swift
//  MessageBoard
//
//  Created by imac-3570 on 2023/7/9.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var messagerLabel: UILabel?
    @IBOutlet weak var contextLabel: UILabel?
    @IBOutlet weak var messagerTextField: UITextField?
    @IBOutlet weak var contextextField: UITextField?
    @IBOutlet weak var messageTableView: UITableView?
    @IBOutlet weak var sendButton: UIButton?
    
    let realm = try! Realm()
    var realmItem: Results<Message>? = nil
    var editStatus = false
    var editIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupUI() {
        messagerLabel?.text = "留言者"
        contextLabel?.text = "留言內容"
        sendButton?.setTitle("傳送", for: .normal)
        sendButton?.isEnabled = false
    }
    
    func setupTableView() {
        fetchRealmItem()
        messageTableView?.dataSource = self
        messageTableView?.delegate = self
        messageTableView?.register(UINib(nibName: "MessageTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: MessageTableViewCell.identified)
      
    }
    
    func fetchRealmItem() {
        realmItem = realm.objects(Message.self)
        print("\(realm.configuration.fileURL)")
    }
    
    @IBAction func clickSend(_ sender: UIButton) {
        if editStatus == false {
            let upload = Message(messager: (messagerTextField?.text)!, message: (contextextField?.text)!)
            try! realm.write({
                realm.add(upload)
            })
        } else {
            let updateIndex = editIndex
            try! realm.write {
                realmItem![updateIndex!].messager = (messagerTextField?.text)!
                realmItem![updateIndex!].message = (contextextField?.text)!
            }
            editIndex = nil
            sender.setTitle("傳送", for: .normal)
            editStatus = false
        }
        fetchRealmItem()
        messageTableView?.reloadData()
        
    }
    
    @IBAction func typeTextField(_ sender: UITextField) {
        if messagerTextField?.text != "" && contextextField?.text != "" {
            sendButton?.isEnabled = true
        } else {
            sendButton?.isEnabled = false
        }
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmItem!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identified, for: indexPath) as! MessageTableViewCell
        cell.messagerLabel?.text = realmItem![indexPath.row].messager
        cell.messageLabel?.text = realmItem![indexPath.row].message
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                        title: "刪除") { action, view, completionHandler in
            let realmItemDelete = self.realmItem![indexPath.row]
            try! self.realm.write {
                self.realm.delete(realmItemDelete)
            }
            self.messageTableView!.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
           
        }
        let configure = UISwipeActionsConfiguration(actions: [delete])
        return configure
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal,
                                      title: "編輯") { action, view, completionHandler in
            self.messagerTextField?.text = self.realmItem![indexPath.row].messager
            self.contextextField?.text =  self.realmItem![indexPath.row].message
            self.editStatus = true
            self.editIndex = indexPath.row
            self.sendButton?.setTitle("編輯", for: .normal)
            completionHandler(true)
        }
        let configure = UISwipeActionsConfiguration(actions: [edit])
        return configure
    }


}
