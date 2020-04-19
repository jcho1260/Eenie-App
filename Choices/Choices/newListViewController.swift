//
//  newListViewController.swift
//  Choices
//
//  Created by Jin Cho on 4/12/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChoiceTableViewCell: UITableViewCell {

    //variables
    @IBOutlet weak var choiceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(choice:String){
        choiceText.text = choice
    }
    
}

class newListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    var user = Auth.auth().currentUser
    var textField: UITextField!
    var refChoices: DatabaseReference?
    var addChoicesRef: DatabaseReference?
    var listInfo: [String:Any]?
    @IBOutlet weak var textChoice: UITextField!
    
    @IBAction func saveList(_ sender: Any) {
         let randomlyChosenChoice = RandomChoice.selectOne(choices: self.allChoices)
         let alertController = UIAlertController(title: "Choice Selected", message: "Randomly selected: \(randomlyChosenChoice.text)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Back to All Lists", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
            }))
         present(alertController, animated: true, completion: nil)
    }
    
    //adding a new choice
    @IBAction func buttonAddChoice(_ sender: UIButton) {
        addChoice()
    }
    
    @IBOutlet weak var tableChoices: UITableView!
    
    var allChoices = [Choice]()
    
    struct Choice: Codable {
        var id: String
        var text: String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = listInfo?["name"] as! String
        
        // Do any additional setup after loading the view.
        
        
        
        //firebase data reference
        reloadChoices()
        self.tableChoices.delegate = self
        self.tableChoices.dataSource = self
        
    }
    
    func reloadChoices(){
        let userID = user?.uid
        
        refChoices = Database.database().reference().child("users").child(userID!).child("lists").child(listInfo?["id"] as! String).child("choices")
        //retreve choices from listID
        refChoices?.observe(.value, with: {(snapshot) in
                    //code to execute when data changes
            var tempChoices = [Choice]()
                    //take data and add to tempChoices array
                    
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                     
                let choiceItem = try JSONDecoder().decode([String:Choice].self, from: jsonData)
                for item in choiceItem{
                    
                    tempChoices.append(item.value)
                }
                         
            } catch let error {
                print("There was an error getting the choices \(error)")
            }
            self.allChoices = tempChoices
            self.tableChoices.reloadData()
                    
        })
    }
    
    func addChoice(){
        let userID = user?.uid
        
        addChoicesRef = Database.database().reference().child("users").child(userID!).child("lists").child(listInfo?["id"] as! String).child("choices").childByAutoId()
        
        if let newItem = self.textChoice.text, newItem != "" {
            let choiceObject = [
                "id": addChoicesRef?.key,
                "text": newItem
            ]
            addChoicesRef?.setValue(choiceObject)
        //                    self.tableView.reloadData()
        }
        textChoice.text = ""
        //addChoicesRef = Database.database().reference()
        //reloadChoices()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choices", for: indexPath) as! ChoiceTableViewCell
        
        cell.set(choice: allChoices[indexPath.row].text)
        //choices = allChoices[indexPath.row]
        //cell.choiceText.text = choices.text
        return cell
    }
    
    
    
//   @objc public func showSaveUserAlertController() {
//       let choiceRef = Database.database().reference().child("lists").childByAutoId()
//
//       let alertCtrl = UIAlertController(title: "Save List", message: "Create a name to save list as", preferredStyle: .alert)
//
//       // Add text field to alert controller
//       alertCtrl.addTextField { (textField) in
//           self.textField = textField
//           self.textField.autocapitalizationType = .words
//           self.textField.placeholder = "e.g Food I Want to Eat"
//       }
//
//       // Add cancel button to alert controller
//       alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//       // "Add" button with callback
//       alertCtrl.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
//           if let newList = self.textField.text, newList != "" {
//               let choiceObject = [
//                   "id": choiceRef.key,
//                   "name": newList
//               ]
//               choiceRef.setValue(choiceObject, withCompletionBlock: { error, ref in
//                   if error == nil {
//                       self.dismiss(animated: true, completion: nil)
//                   }
//                   else{
//
//                   }
//               })
//           }
//       }))
//
//       present(alertCtrl, animated: true, completion: nil)
//   }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
