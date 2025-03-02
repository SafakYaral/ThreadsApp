//
//  SettingsViewController.swift
//  ThreadsApp
//
//  Created by Safak Yaral on 10.11.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logoutClicked(_ sender: Any){
       do {
           try Auth.auth().signOut()
           performSegue(withIdentifier: "toViewController", sender: nil)
           
        }catch {
           print("error")
       }
        
    }
   
    

}
