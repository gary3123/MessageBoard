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
    @IBOutlet weak var contexTextView: UITextView?
    @IBOutlet weak var messageTableView: UITableView?
    @IBOutlet weak var sendButton: UIButton?
    
    let realm = try! Realm()
    var realmItem: [MessageStruct]? = []
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
        contexTextView?.layer.borderColor = UIColor.systemGray5.cgColor
        contexTextView?.layer.borderWidth = 1
        contexTextView?.layer.cornerRadius = 10
        contexTextView?.delegate = self
    }
    
    func setupTableView() {
        fetchRealmItem()
        messageTableView?.dataSource = self
        messageTableView?.delegate = self
        messageTableView?.register(UINib(nibName: "MessageTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: MessageTableViewCell.identified)
      
    }
    
    func fetchRealmItem() {
        realmItem = []
        let fetchToRealm = realm.objects(Message.self)
        for message in fetchToRealm {
            let item = MessageStruct(id: message._id, messager: message.messager, message: message.message, timeStamp: message.timeStamp)
            realmItem?.append(item)
        }
        print("\(realm.configuration.fileURL)")
    }
    
    @IBAction func clickSend(_ sender: UIButton) {
        if editStatus == false {
            let nowTimeStamp = Int(Date().timeIntervalSince1970)
            let upload = Message(messager: (messagerTextField?.text)!, message: (contexTextView?.text)!, timeStamp: nowTimeStamp)
            try! realm.write({
                realm.add(upload)
            })
        } else {
            let fetchToRealm = self.realm.objects(Message.self)
            let updateId = realmItem![editIndex!].id
            let messageInProgress = fetchToRealm.where {
                $0._id == updateId
            }
            try! realm.write {
                messageInProgress[0].messager = (messagerTextField?.text)!
                messageInProgress[0].message = (contexTextView?.text)!
            }
            editIndex = nil
            sender.setTitle("傳送", for: .normal)
            editStatus = false
        }
        messagerTextField?.text = ""
        contexTextView?.text = ""
        fetchRealmItem()
        messageTableView?.reloadData()
        
    }
    
    @IBAction func typeTextField(_ sender: UITextField) {
        if messagerTextField?.text != "" && contexTextView?.text != "" {
            sendButton?.isEnabled = true
        } else {
            sendButton?.isEnabled = false
        }
    }
    

    
    @IBAction func clickSortButton() {
        Alert.showActionSheet(cancelTitle: "取消", vc: self, newToOldConfirmTitle: "新到舊排序", oldToNewConfirmTitle: "舊到新排序") {
            self.realmItem?.sort(by: { first, second in
                return first.timeStamp > second.timeStamp
            })
            self.messageTableView?.reloadData()
        } oldToNewConfirm: {
            self.realmItem?.sort(by: { first, second in
                return first.timeStamp < second.timeStamp
            })
            self.messageTableView?.reloadData()
        }
    }
    
//    func sortByNewToOld() {
//        realmItem = realmItem?.sorted(by: { first, second in
//            return first.timeStamp > second.timeStamp
//        })
//    }

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
            let realmItemDeleteUid = self.realmItem![indexPath.row].id
            let fetchToRealm = self.realm.objects(Message.self)
            let messageInProgress = fetchToRealm.where {
                $0._id == realmItemDeleteUid
            }
            try! self.realm.write {
                self.realm.delete(messageInProgress)
            }
            self.realmItem?.remove(at: indexPath.row)
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
            self.contexTextView?.text =  self.realmItem![indexPath.row].message
            self.editStatus = true
            self.editIndex = indexPath.row
            self.sendButton?.setTitle("編輯", for: .normal)
            completionHandler(true)
        }
        let configure = UISwipeActionsConfiguration(actions: [edit])
        return configure
    }


}

extension MainViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if messagerTextField?.text != "" && contexTextView?.text != "" {
            sendButton?.isEnabled = true
        } else {
            sendButton?.isEnabled = false
        }
    }
}
