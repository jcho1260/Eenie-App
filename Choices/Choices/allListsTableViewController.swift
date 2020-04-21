//
//  allListsTableViewController.swift
//  Choices
//
//  Created by Jin Cho on 4/8/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CodableFirebase
import FirebaseAuth

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listLab: UILabel!
    var listID: String!
    var listName: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class allListsTableViewController: UITableViewController {

    var allLists = [List]()
    var textField: UITextField!
    var newList: [String:Any]?
    var listRef: DatabaseReference?
    var choiceRef: DatabaseReference?
    var delRef: DatabaseReference?
    var user = Auth.auth().currentUser
    
    struct List: Codable {
        var choices: [String:Choice]? = [String:Choice]()
        var id: String? = nil
        var name: String? = nil
    }
    
    struct Choice: Codable {
        var id: String
        var text: String
    }
    
    
    
    @IBAction func newListButton(_ sender: UIBarButtonItem) {
        let userID = self.user?.uid
        
        choiceRef = Database.database().reference().child("users").child(userID!).child("lists").childByAutoId()
        
        let alertController = UIAlertController(title: "New List", message: "Create a name to save list as", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            self.textField = textField
            self.textField.autocapitalizationType = .words
            self.textField.placeholder = "e.g Food I Want to Eat"
        }
    
        // Add cancel button to alert controller
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // "Manual text input" button with callback
        alertController.addAction(UIAlertAction(title: "Manual Text Input", style: .default, handler: { action in
            if let newItem = self.textField.text, newItem != "" {
                let choiceObject = [
                    "id": self.choiceRef?.key,
                    "name": newItem,
                    "choices": [String:Choice]()
                ] as [String: Any]
                self.newList = choiceObject
                self.choiceRef?.setValue(choiceObject, withCompletionBlock: { error, ref in})
                self.performSegue(withIdentifier: "newListViewController", sender: self)
            }
        }))
        present(alertController, animated: true, completion: nil)
        
        //"Scan in input" button
        alertController.addAction(UIAlertAction(title: "Scan-in Text", style: .default, handler: {action in
            if let newItem = self.textField.text, newItem != "" {
                            let choiceObject = [
                                "id": self.choiceRef?.key,
                                "name": newItem,
                                "choices": [String:Choice]()
                            ] as [String: Any]
                            self.newList = choiceObject
                            self.choiceRef?.setValue(choiceObject, withCompletionBlock: { error, ref in})
                self.performSegue(withIdentifier: "MLViewController", sender: self)
            }
        }))
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLists()
        self.modalPresentationStyle = .overFullScreen
        assignBackground()
    }
    
    func assignBackground(){
        let backgroundImage = UIImageView(image: UIImage(named: "tiger-transparent"))
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImage
    }
    
    //getting all the lists and showing in table view
    func observeLists(){
        let userID = self.user?.uid
        
        listRef = Database.database().reference().child("users").child(userID!).child("lists")
        print("here is the list start: \n")
        listRef?.observe(.value, with: {snapshot in
            
            var tempLists = [List]()
            
            guard let value = snapshot.value as? [String: Any] else { return }
                   do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        print(jsonData)
                    
                    let listItem = try JSONDecoder().decode([String:List].self, from: jsonData)
                    for item in listItem{
                        tempLists.append(item.value)
                    }
                   } catch let error {
                       print(error)
                   }

            self.allLists = tempLists
            self.tableView.reloadData()
        })
    }
    
    
    
    // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
        //send Lists object to new list VC so that choices can be added to Lists node in database
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
        print("segue id:", segue.identifier)
        if(segue.identifier == "newListViewController"){
                print("segue id:", segue.identifier)
                let displayVC = segue.destination as! newListViewController
                displayVC.listInfo = newList
            }
            else if(segue.identifier == "oldListViewController"){
            print("segue id:", segue.identifier)
                let displayTVC = segue.destination as! oldListTableViewController
                let myRow = tableView!.indexPathForSelectedRow
                let myCurrCell = tableView!.cellForRow(at: myRow!) as! ListTableViewCell
                // set the destVC variables from the selected row
                displayTVC.listID = myCurrCell.listID!
                displayTVC.listName = myCurrCell.listName!
        }
        else if(segue.identifier == "MLViewController"){
            print("segue id:", segue.identifier)
            let displayVC = segue.destination as! MLViewController
            displayVC.listInfo = newList
        }
        else if segue.identifier == "logOutSegue" {
            let destinationViewController = segue.destination as! ViewController
            // setup the destination controller
        }
        
            
       }

    // MARK: - Table view data source
   
  
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allLists.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
        let lists: List
        lists = allLists[indexPath.row]
        cell.listLab.text = lists.name
        cell.listID = lists.id
        cell.listName = lists.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // #warning Incomplete implementation, return the number of rows
        cell.backgroundColor = UIColor.clear
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let userID = self.user?.uid
            let listID = allLists[indexPath.row].id
            delRef = Database.database().reference().child("users").child(userID!).child("lists").child(listID!)
            delRef?.removeValue()
            
        }
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    
    

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

    
   
    

}
