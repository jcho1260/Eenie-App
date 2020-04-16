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

    @IBOutlet weak var choiceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class newListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user = Auth.auth().currentUser
    
    var textField: UITextField!
    var refChoices: DatabaseReference!
    
    var listInfo: [String:Any]?
    
    @IBOutlet weak var textChoice: UITextField!
    
    @IBAction func buttonAddChoice(_ sender: UIButton) {
        addChoice()
    }
    
    //Once Jin's part work this will randomly choice from the "allchoice" list
    @IBAction func RandomlySelect(_ sender: Any) {
        let randomlyChosenChoice = RandomChoice.selectOne(choices: self.allChoices)
        showAlert(title: "Choice Selected", message: "Randomly selected \(randomlyChosenChoice.text)")
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
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(showSaveUserAlertController))
        
        //firebase data reference
        refChoices = Database.database().reference()
        reloadChoices()
        self.tableChoices.delegate = self
        self.tableChoices.dataSource = self
        
    }
    
    func reloadChoices(){
        let userID = user?.uid
        
        //retreve choices from listID
        refChoices.child("users").child(userID!).child("lists").child(listInfo?["id"] as! String).child("choices").observe(.value, with: {(snapshot) in
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
                    
        //            for child in snapshot.children{
        //                if let childSnapshot = child as? DataSnapshot,
        //                    let dict = childSnapshot.value as? [String:Any],
        //                    let text = dict["text"] as? String,
        //                    let id = dict["id"] as? String {
        //
        //                        let item = Choices(id: id, text: text)
        //                        tempChoices.append(item)
        //
        //                    }
        //
        //            }
                    
            self.allChoices = tempChoices
            self.tableChoices.reloadData()
                    
        })
    }
    
    func addChoice(){
        refChoices = refChoices.child("lists").child(listInfo?["id"] as! String).child("choices").childByAutoId()
        if let newItem = self.textChoice.text, newItem != "" {
            let choiceObject = [
                "id": refChoices.key,
                "text": newItem
            ]
            refChoices.setValue(choiceObject)
        //                    self.tableView.reloadData()
        }
        refChoices = Database.database().reference()
        // reloadChoices()
        //reloadChoices()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choices", for: indexPath) as! ChoiceTableViewCell
        let choices: Choice
        choices = allChoices[indexPath.row]
        cell.choiceText.text = choices.text
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
