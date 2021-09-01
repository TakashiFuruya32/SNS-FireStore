//
//  TimeLineViewController.swift
//  SnsApp
//
//  Created by HechiZan on 2021/08/25.
//

import UIKit
import Firebase
import Photos
import ActiveLabel//#をタップすることができる
import SDWebImage

class TimeLineViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate {


    
    var loadDBModel = LoadDBModel()
    
    
    var roomNumber = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDBModel.loadOKDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadOK(check: Int) {
        
        if check == 1{
            
            tableView.reloadData()
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        loadDBModel.loadContets(roomNumber: String(roomNumber))
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
         //値を渡しながら画面遷移
            let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
            editVC.roomNamber = roomNumber
            editVC.passImage = selectedImage
            self.navigationController?.pushViewController(editVC, animated: true)
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 682
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return loadDBModel.dataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //アイコン
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].profileImage),completed: nil)
        profileImageView.layer.cornerRadius = 50
        
        //ユーザー名
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel.dataSets[indexPath.row].userName
        
        //投稿画像
        let contentImageView = cell.contentView.viewWithTag(3) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage),completed: nil)
        
        //コメント
        let commentLabel = cell.contentView.viewWithTag(4) as! ActiveLabel
        commentLabel.enabledTypes = [.hashtag]//#をタップできる
        commentLabel.text = "\(loadDBModel.dataSets[indexPath.row].comment)"
        commentLabel.handleHashtagTap { (hashTag) in
            
            print(hashTag)
            
            let hashTagVC = self.storyboard?.instantiateViewController(identifier: "hushTagVC") as! HushTagViewController
            hashTagVC.hushTag = hashTag
            self.navigationController?.pushViewController(hashTagVC, animated: true)
            
            
        }
        
        return cell
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func openCamera(_ sender: Any) {
        
        
        showAlert()
    }
    
}
