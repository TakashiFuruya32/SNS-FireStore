//
//  SendDBModel.swift
//  SnsApp
//
//  Created by HechiZan on 2021/08/25.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

//データーベースへ送信する機能を集約したクラス
class SendDBModel{
    
    var userID = String()
    var userName = String()
    var comment = String()
    var userImageString = String()
    var contentImageData = Data()
    
    var db = Firestore.firestore()

    
    init(){
        
    }
    
    init(userID:String,userName:String,comment:String,userImageString:String,contentImageData:Data){
        
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.userImageString = userImageString
        self.contentImageData = contentImageData
        
    }
    
    func sendData(roomNumber:String){
        
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(contentImageData,metadata: nil) {
            (metadata,error) in
            
            if error != nil{
                
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil{
                    
                    return
                }
                
                self.db.collection(roomNumber).document().setData(["userID": self.userID as Any,"userName":self.userName as Any,"comment":self.comment as Any,"userImage":self.userImageString as Any,"contentImage":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970])
                
            }

           
        }
        
        
    }
    
    func sendProfileImageData(data:Data){
        
        
        let image = UIImage(data:data)
        let profileImage = image!.jpegData(compressionQuality: 0.1)
        
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(profileImage!,metadata: nil) {
            (metadata,error) in
            
            if error != nil{
                
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil{
                    
                    return
                }
                
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }

           
        }
    }
    
    
    func sendHashTag(hashTag:String){
            
            let imageRef = Storage.storage().reference().child(hashTag).child("\(UUID().uuidString +  String(Date().timeIntervalSince1970)).jpg")

            
            imageRef.putData(contentImageData, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                       print(error)
                        return
                    }

                   
                imageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error)
                            return
                        }

                    self.db.collection(hashTag).document().setData(["userID":self.userID as Any,"userName":self.userName as Any,"comment":self.comment as Any,"userImage":self.userImageString as Any,"contentImage":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970])
                                    
      
                })
            })
            
     
        }
    
}
