//
//  MLTableViewController.swift
//  Choices
//
//  Created by Michelle Tai on 4/19/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MLTableViewController: UITableViewController {
    var MLOptionsVar:[String] = ["hi", "lool","bye"]
    
    var savedSelections:[String] = []
    
    var isAllSelected:Bool = false
    
    var listInfo:[String:Any]?
    
    var choicesRef: DatabaseReference?
    
    var user = Auth.auth().currentUser
    
    struct Choice: Codable {
        var id: String
        var text: String
    }

    @IBOutlet weak var selectAllButton: UIBarButtonItem!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //    let selectBtn = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(didPressSelect))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = selectButton
        self.navigationItem.leftBarButtonItem = nil
        //create the button, but dont show yet
        setDisabled(btn: selectAllButton)
        setDisabled(btn: saveButton)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setDisabled(btn : UIBarButtonItem){
        btn.isEnabled = false
        btn.tintColor = UIColor.clear
    }
    
    func setEnabled(btn : UIBarButtonItem){
        btn.isEnabled = true
        btn.tintColor = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MLOptionsVar.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MLCell")
        cell.textLabel?.text = MLOptionsVar[indexPath.row]
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "MLTableViewToOld"){
            print("segue id:", segue.identifier)
            let displayVC = segue.destination as! oldListTableViewController
            displayVC.listID = listInfo?["id"] as! String
            displayVC.listName = listInfo?["name"] as! String
        }
        
    }
    
    
    // MARK: - Multiple selection methods.

    /// - Tag: table-view-should-begin-multi-select
    override func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// - Tag: table-view-did-begin-multi-select
    override func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        // Replace the Edit button with Done, and put the
        // table view into editing mode.
        self.setEditing(true, animated: true)
    }
    
    /// - Tag: table-view-did-end-multi-select
    override func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }
    
    @IBAction func didPressSelect(_ sender: Any) {
        if(!isEditing){
            self.setEditing(true, animated: true)
            selectButton.title = "Cancel"
            setEnabled(btn: selectAllButton)
            setEnabled(btn: saveButton)
        }
        else{
            self.setEditing(false, animated: true)
            selectButton.title = "Select"
            setDisabled(btn: selectAllButton)
            setDisabled(btn: saveButton)
        }
    }
    
    //
    
    @IBAction func didPressSelectAll(_ sender: UIBarButtonItem) {
        let totalRows = tableView.numberOfRows(inSection: 0)
        if(totalRows > 0){
            if(!isAllSelected){
                for currRow in 0..<totalRows {
                    tableView.selectRow(at: IndexPath(row: currRow, section: 0), animated: false, scrollPosition: .none)
                }
                self.isAllSelected = true
                selectAllButton.title = "Deselect All"
            }
            else{
                for currRow in 0..<totalRows {
                    tableView.deselectRow(at: IndexPath(row: currRow, section: 0), animated: false)
                }
                self.isAllSelected = false
                selectAllButton.title = "Select All"
            }
        }
    }
    
    @IBAction func saveSelectedPressed(_ sender: UIBarButtonItem) {
        savedSelections = []
        guard let indexPaths = self.tableView.indexPathsForSelectedRows else{ return }
        for indexPath in indexPaths{
    savedSelections.append(MLOptionsVar[indexPath.row])
        }
        
        let userID = user?.uid
        choicesRef = Database.database().reference().child("users").child(userID!).child("lists").child(listInfo?["id"] as! String).child("choices")
        
        for choiceString in savedSelections{
            let choicesRefNew = choicesRef?.childByAutoId()
            let choiceObject = [
                "id": choicesRefNew?.key,
                "text": choiceString
            ]
            choicesRefNew?.setValue(choiceObject)
        }
        
        print(savedSelections)
        
        self.performSegue(withIdentifier: "MLTableViewToOld", sender: self)
    }
    
}

