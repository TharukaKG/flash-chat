//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = K.appName
        
        fetchMessages()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.register(UINib(nibName: K.yourNibName, bundle: nil), forCellReuseIdentifier: K.yourCellIdentifier)
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let sender = Auth.auth().currentUser?.email, let message = messageTextfield.text{
            
            let message = [
                K.FStore.senderField: sender,
                K.FStore.bodyField: message,
                K.FStore.dateField: Date().timeIntervalSince1970
            ] as [String : Any]
            
            Firestore.firestore().collection(K.FStore.collectionName).addDocument(data: message) { (error) in
                if error != nil{
                    print("something went wrong\(String(describing: error))")
                }else{
                    print("added succesfully")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
            
        }
        
    }
    
    private func fetchMessages(){
        
        Firestore.firestore().collection(K.FStore.collectionName).order(by: K.FStore.dateField, descending: true).addSnapshotListener{ snapShot, error in
            
            self.messages = []
            
            if error != nil{
                print("something went wrong\(String(describing: error))")
            }else{
                for document in snapShot!.documents{
                    let sender = document[K.FStore.senderField] as! String
                    let message = document[K.FStore.bodyField] as! String
                    
                    self.messages.append(Message(sender: sender, body: message))
                    self.tableView.reloadData()
                    
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    
                }
            }
        }
        
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch{
            print("someting went wrong:::\(error)")
        }
    }
    
}

//MARK: - UITableView Data Source
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellOwner = messages[indexPath.row].sender
        
        if(cellOwner == Auth.auth().currentUser?.email){
            let myCell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! TableViewCell
            myCell.labelBody.text = messages[indexPath.row].body
            return myCell
        }else{
            let yourCell = tableView.dequeueReusableCell(withIdentifier: K.yourCellIdentifier, for: indexPath) as! SenderTableViewCell
            yourCell.labelMessage.text = messages[indexPath.row].body
            return yourCell
        }
    }
    
    
}
