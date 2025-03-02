//
//  ViewController.swift
//  ThreadsApp
//
//  Created by Safak Yaral on 10.11.2024.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    @IBAction func signInClicked(_ sender: Any) {
       
        if emailText.text?.isEmpty == false || passwordText.text?.isEmpty == false {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: error!.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "ERROR", messageInput: "Username or Password is empty")
            
        }
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text?.isEmpty == false || passwordText.text?.isEmpty == false {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { result, error in
               
                if error != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: error!.localizedDescription)
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "ERROR", messageInput: "Username or Password is empty")
            
        }
            
        
        
    }
    
     func makeAlert(titleInput: String, messageInput: String){
         let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
         let okButton = UIAlertAction(title: "OK", style: .default)
         alert.addAction(okButton)
         self.present(alert, animated: true, completion: nil)
    }
  
}

