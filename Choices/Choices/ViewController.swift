//
//  ViewController.swift
//  Choices
//
//  Created by Callie Scholer on 3/30/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    var db: OpaquePointer?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    //creating a database file url to hold the data
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    .appendingPathComponent("choiceLists.sqlite")
    
    //opening database file (error if unable to open)
    if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
        print("Error opening database")
    }
    
    //creating SQLite Table
   
    
  }


}

