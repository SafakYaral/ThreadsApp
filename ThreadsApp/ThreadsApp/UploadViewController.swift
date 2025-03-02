//
//  UploadViewController.swift
//  ThreadsApp
//
//  Created by Safak Yaral on 10.11.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func imageTapped(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //kullanıcı bunu fotoğrafı seçince ne olacak onu burada yazdık.
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert (titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference() //hangi kloserde çalışacağımızı belirittik.nereye kaydedicez
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) //görüntüyü bastırıp küçülttük
{
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child(uuid + ".jpg") //child kullanarak media klasörünün içine image jpg yi kaydetecegiz.
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                if let error {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                } else {
                     
                    imageRef.downloadURL { (url, error) in //url e çevirirken hata yoksa bu satıra girip url olarak kayıt eder.
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            //kullanıcı bir resim paylaştığında data base işlemleri bu şekilde olur.ve data base e kaydedilir.
                             let firestoreDatabase = Firestore.firestore()
                            
                             var firestoreRef : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "userId" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes " : 0] as [String : Any] //data base kayıt işlemleri.
                            
                            firestoreRef = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                                    
                                }else {
                                    
                                    self.imageView.image = UIImage(named : "select")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 // feed(0) , upload(1) , settings(2)
                                 
                                }
                            })
                            
                        }
                    }
                    
                }
            }
        }
    }
    
   

}
 
