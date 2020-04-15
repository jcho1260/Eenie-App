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
    
    struct List: Codable {
        var choices: [String:Choice]? = nil
        var id: String? = nil
        var name: String? = nil
    }
    
    struct Choice: Codable {
        var id: String
        var text: String
    }
    
    @IBAction func newListButton(_ sender: UIBarButtonItem) {
        choiceRef = Database.database().reference().child("lists").childByAutoId()
        
        let alertController = UIAlertController(title: "New List", message: "Create a name to save list as", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            self.textField = textField
            self.textField.autocapitalizationType = .words
            self.textField.placeholder = "e.g Food I Want to Eat"
        }
    
        // Add cancel button to alert controller
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // "Add" button with callback
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let newItem = self.textField.text, newItem != "" {
                let choiceObject = [
                    "id": self.choiceRef?.key,
                    "name": newItem
                ]
                self.newList = choiceObject
                self.choiceRef?.setValue(choiceObject, withCompletionBlock: { error, ref in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
                self.performSegue(withIdentifier: "newListViewController", sender: self)
                
        //                    self.tableView.reloadData()
            }
        }))
        present(alertController, animated: true, completion: nil)
        
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeLists()
        
        //ref.child("newList").observeEventType
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //getting all the lists and showing in table view
    func observeLists(){
        listRef = Database.database().reference().child("lists")
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
                       // let item = Lists(id: listItem.id, name: listItem.name, choices: listItem.choices)
                        
                   } catch let error {
                       print(error)
                   }
            
//            for child in snapshot.children{
//                if let childSnapshot = child as? DataSnapshot,
//                    let dict = childSnapshot.value as? [String:Any],
//                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: []),
//                    let choiceItem = try JSONDecoder().decode(List.self, from: jsonData),
//                    //let name = dict["name"] as? String,
//                    //let choices = dict["choices"] as? [Choices]
//                    let name = choiceItem.name,
//                    let choices = choiceItem.choices{
//                    let item = Lists(id: childSnapshot.key, name: name, choices:choices)
//                    tempLists.append(item)
//                    }
//
//            }
        
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
            if(segue.identifier == "newListViewController"){
                let displayVC = segue.destination as! newListViewController
                displayVC.listInfo = newList
            }
            if(segue.identifier == "oldListViewController"){
                let displayTVC = segue.destination as! oldListTableViewController
                let myRow = tableView!.indexPathForSelectedRow
                let myCurrCell = tableView!.cellForRow(at: myRow!) as! ListTableViewCell
                
                // set the destVC variables from the selected row
                displayTVC.listID = myCurrCell.listID
                displayTVC.listName = myCurrCell.listName
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
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
