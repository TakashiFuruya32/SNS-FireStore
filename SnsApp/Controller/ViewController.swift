//
//  ViewController.swift
//  SnsApp
//
//  Created by HechiZan on 2021/08/25.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    var urlString = String()
    
    var sendDBModel = SendDBModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let checkModel = CheckModel()
        checkModel.showCheckPermission()

        
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func login(_ sender: Any) {
        
        //匿名ログイン
        Auth.auth().signInAnonymously { (result,error) in
            
            if error != nil{
                
              
                return
            }
            //ユーザーがいるか確認
            let user = result?.user
            print(user.debugDescription)
            
            //画面遷移
            let selectVC = self.storyboard?.instantiateViewController(identifier: "selectVC") as! SelectRoomViewController
            
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            
            //画像を圧縮
            let data = self.profileImageView.image?.jpegData(compressionQuality: 0.01)
            //画像をクラウドに送信
            self.sendDBModel.sendProfileImageData(data:data!)
            
            
            self.navigationController?.pushViewController(selectVC, animated: true)
            
        }
        
        
        
    }
    
    func doCamera(){
            
            let sourceType:UIImagePickerController.SourceType = .camera
            
            //カメラ利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
                
            }
            
        }
        
        
        func doAlbum(){
            
            let sourceType:UIImagePickerController.SourceType = .photoLibrary
            
            //カメラ利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
                
            }
            
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if info[.originalImage] as? UIImage != nil{
                
                let selectedImage = info[.originalImage] as! UIImage
                profileImageView.image = selectedImage
                picker.dismiss(animated: true, completion: nil)
                
            }
            
        }
       
    @IBAction func tapImageView(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
    }
    
    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         
         picker.dismiss(animated: true, completion: nil)
         
     }
     
     
     //アラート
     func showAlert(){
         
         let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
         
         let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
             
             self.doCamera()
             
         }
         let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
             
             self.doAlbum()
             
         }

         let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
         
         
         alertController.addAction(action1)
         alertController.addAction(action2)
         alertController.addAction(action3)
         self.present(alertController, animated: true, completion: nil)
         
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         textField.resignFirstResponder()
         
     }
    
    
}

