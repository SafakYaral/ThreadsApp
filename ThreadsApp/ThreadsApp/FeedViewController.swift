//
//  FeedViewController.swift
//  ThreadsApp
//
//  Created by Safak Yaral on 10.11.2024.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray : [Int] = []
    var userImageArray = [String]()
    
    var documentIDArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    func getDataFromFirestore(){
        let firestoreDataBase = Firestore.firestore()
        
         let settings = firestoreDataBase.settings
         firestoreDataBase.settings = settings
         
        firestoreDataBase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in //database e kaydedilen herşeyi burda snaoshot ile uygulamaya tarihe göre çektik.
            if error != nil{
                print(error?.localizedDescription ?? "error!") 
            }else {
                if snapshot?.isEmpty != true{
                    
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let userId = document.get("userId") as? String{
                            self.userEmailArray.append(userId)
                            
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                            
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userEmailArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //prototik cell in id sini kullanarak veri tabanından aldığımız değerleri burda matchleyip gösterdik.
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
           
            cell.userEmailLabel.text = userEmailArray[indexPath.row]
            cell.commentLabel.text = userCommentArray[indexPath.row]
            
            if  likeArray.count > indexPath.row{
                cell.likeLabel.text = String(likeArray[indexPath.row])
            }else {
                cell.likeLabel.text = "0"
            }
           
            cell.userImageView.image = UIImage(named: userImageArray[indexPath.row])
            
            cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row])) //kaydedilen görseli veri tabanından çekme.
            cell.documentIdLabel.text = documentIDArray[indexPath.row]
            
            
            return cell
        }
        
        
        
        
        
    }

