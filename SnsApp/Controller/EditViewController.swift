//
//  EditViewController.swift
//  SnsApp
//
//  Created by HechiZan on 2021/08/25.
//

import UIKit
import Firebase
import FirebaseAuth

class EditViewController: UIViewController {
    
    
    var roomNamber = Int()
    var passImage = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var userName = String()
    var userImageString = String()
    
    @IBOutlet weak var sendButton: UIButton!
    
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        profileImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        userNameLabel.text = userName
        contentImageView.image = passImage
        
        profileImageView.layer.cornerRadius = 50
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        textField.frame.origin.y = screenSize.height - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
        //空判定を
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func searchHashTag(){

     let hashTagText = textField.text as NSString?
            do{
                let regex = try NSRegularExpression(pattern: "#\\S+", options: [])
                for match in regex.matches(in: hashTagText! as String, options: [], range: NSRange(location: 0, length: hashTagText!.length)) {

                    let passedData = self.passImage.jpegData(compressionQuality: 0.01)
                    let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, comment: self.textField.text!, userImageString:self.userImageString,contentImageData:passedData!)
                    sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
                }
            }catch{
                
            }
    }
    
    @IBAction func send(_ sender: Any) {
        
        //送信
        if textField.text?.isEmpty == true{
            
            return
        }
        
        searchHashTag()
        
        let passData = passImage.jpegData(compressionQuality: 0.01)
        
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, comment: textField.text!, userImageString: userImageString, contentImageData: passData!)
        
        sendDBModel.sendData(roomNumber: String(roomNamber))
        self.navigationController?.popViewController(animated: true)
        
        
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
