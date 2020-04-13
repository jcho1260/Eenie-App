//
//  PhotoUploadViewController.swift
//  Choices
//
//  Created by Callie Scholer on 4/13/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit



class PhotoUploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @IBOutlet weak var myImageView: UIImageView!
  
  @IBAction func importImage(_ sender: UIButton) {
    
    let image = UIImagePickerController()
    
    image.delegate = self
    image.sourceType = UIImagePickerController.SourceType.photoLibrary
    image.allowsEditing = false
    
    self.present(image, animated: true) {
    //after it is complete
  }
    
}
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey(rawValue: <#T##String#>)] as? UIImage {
      myImageView.image = image
    } else {
      //error message
    }
    
    self.dismiss(animated:true, completion: nil)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
