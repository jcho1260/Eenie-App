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

class newListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var textField: UITextField!
    var refChoices: DatabaseReference!
    
    @IBOutlet weak var textChoice: UITextField!
    @IBAction func buttonAddChoice(_ sender: UIButton) {
        addChoice()
    }
    @IBOutlet weak var tableChoices: UITableView!
    
    var allChoices = [Choices]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refChoices = Database.database().reference().child("choices")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(showSaveUserAlertController))
        refChoices.observe(.value, with: {(snapshot) in
            var tempChoices = [Choices]()
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let text = dict["text"] as? String,
                    let id = dict["id"] as? String {
                    
                        let item = Choices(id: id, text: text)
                        tempChoices.append(item)
                    
                    }
                
            }
            
            self.allChoices = tempChoices
            self.tableChoices.reloadData()
            
        })
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choices", for: indexPath) as! ChoiceTableViewCell
        let choices: Choices
        choices = allChoices[indexPath.row]
        
        cell.choiceText.text = choices.text
        return cell 
    }
    
    func addChoice(){
        let ref = refChoices.childByAutoId()
        if let newItem = self.textChoice.text, newItem != "" {
            let choiceObject = [
                "id": ref.key,
                "text": newItem
            ]
            ref.setValue(choiceObject)
        //                    self.tableView.reloadData()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
