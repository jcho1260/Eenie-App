//
//  oldListTableViewController.swift
//  Choices
//
//  Created by Jin Cho on 4/12/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class OldChoiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var choiceLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(choice:String){
        choiceLab.text = choice
    }

}

class oldListTableViewController: UITableViewController {

    struct List: Codable {
           var choices: [Choice]
           var name: String
           var id: String
       }
       
    struct Choice: Codable {
           var text: String
           var id: String
    }
    
    var textField: UITextField!
    var allChoices = [Choice]()
    var listID: String!
    var listName: String!
    var choiceRef: DatabaseReference?
    var newChoiceRef: DatabaseReference?
    var user = Auth.auth().currentUser
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = listName
            print(listName)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddUserAlertController))
            observeChoices()
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false

            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }

        // MARK: - Table view data source
        
        
        func observeChoices(){
            let userID = self.user?.uid
            choiceRef = Database.database().reference().child("users").child(userID!).child("lists").child(listID).child("choices")
            
            choiceRef?.observe(.value, with: {snapshot in
                
                var tempChoices = [Choice]()
                
                guard let value = snapshot.value as? [String: Any] else { return }
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                            let choiceItem = try JSONDecoder().decode([String:Choice].self, from: jsonData)
                            // let item = Lists(id: listItem.id, name: listItem.name, choices: listItem.choices)
                            for item in choiceItem{
                                tempChoices.append(item.value)
                            }
                            
                        } catch let error {
                            print(error)
                        }
                
//                for child in snapshot.children{
//                    if let childSnapshot = child as? DataSnapshot,
//                        let dict = childSnapshot.value as? [String:Any],
//                        let text = dict["text"] as? String,
//                        let id = dict["id"] as? String {
//
//                            let item = Choices(id: id, text: text)
//                            tempChoices.append(item)
//                        }
//
//                }
                
                self.allChoices = tempChoices
                self.tableView.reloadData()
            }
            )
            
        }

        @objc public func showAddUserAlertController() {
            let userID = self.user?.uid
            newChoiceRef = Database.database().reference().child("users").child(userID!).child("lists").child(listID).child("choices").childByAutoId()
            
            let alertCtrl = UIAlertController(title: "Add Choice", message: "Add a new choice to the list", preferredStyle: .alert)

            // Add text field to alert controller
            alertCtrl.addTextField { (textField) in
                self.textField = textField
                self.textField.autocapitalizationType = .words
                self.textField.placeholder = "e.g Hamburger"
            }

            // Add cancel button to alert controller
            alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            // "Add" button with callback
            alertCtrl.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                if let newItem = self.textField.text, newItem != "" {
                    let choiceObject = [
                        "id": self.newChoiceRef?.key,
                        "text": newItem
                    ]
                    self.newChoiceRef?.setValue(choiceObject, withCompletionBlock: { error, ref in
//                        if error == nil {
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                        else{
//                            
//                        }
                    })
//                    self.tableView.reloadData()
                }
            }))

            present(alertCtrl, animated: true, completion: nil)
        }

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return allChoices.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "choice", for: indexPath) as! OldChoiceTableViewCell
            cell.set(choice: allChoices[indexPath.row].text)
            return cell
        }
        

        /*
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        */

        
        // Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            self.users.remove(at: indexPath.row)
    //            self.tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
        

        /*
        // Override to support rearranging the table view.
        override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
        */

        /*
        // Override to support conditional rearranging of the table view.
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the item to be re-orderable.
            return true
        }
        */

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

}
