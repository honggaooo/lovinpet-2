//
//  MyProfileViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MyProfileViewController: UIViewController, EditProtocal {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = UIColor.white
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        
        Database.database().reference().child(Global.sharedInstance.user.uid)
            .observe(.value, with: { (snapshot: DataSnapshot) in
                
                if snapshot.value != nil && !(snapshot.value is NSNull) {
                    let dic = snapshot.value as! [String: AnyObject]
                    
                    self.nameLabel.text = "name: \(dic["name"] ?? "" as AnyObject)"
                    self.nameLabel.sizeToFit()
                    self.breedLabel.text = "breed: \(dic["breed"] ?? "" as AnyObject)"
                    self.breedLabel.sizeToFit()
                    self.ageLabel.text = "age: \(dic["age"] ?? "" as AnyObject)"
                    self.ageLabel.sizeToFit()
                    self.genderLabel.text = "gender: \(dic["gender"] ?? "" as AnyObject)"
                    self.genderLabel.sizeToFit()
                    
                    Global.sharedInstance.avatar = dic["avatar"] as! String
                    Global.sharedInstance.nickname = dic["name"] as! String
                    Global.sharedInstance.age = dic["age"] as! String
                    Global.sharedInstance.breed = dic["breed"] as! String
                    Global.sharedInstance.gender = dic["gender"] as! String
                    
                    self.avatarImageView.kf.setImage(with: URL(string: dic["avatar"] as! String))
                }
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            let controller = segue.destination as! EditProfileViewController
            controller.delegate = self
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func save(name: String, breed: String, age: String, gender: String, image: UIImage) {
        // Data in memory
        let data = UIImageJPEGRepresentation(image, 1.0)!
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(Date().timeIntervalSince1970).jpg")
        
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        imageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()
            
            let ref = Database.database().reference()
            
            var profile = [String: Any]()
            profile["name"] = name
            profile["breed"] = breed
            profile["age"] = age
            profile["gender"] = gender
            profile["avatar"] =  downloadURL?.absoluteString
            
            ref.child(Global.sharedInstance.user.uid).setValue(profile) { (error, ref) in
                if error != nil {
                    print("error: \(error!.localizedDescription)")
                }
            }
        }
    }

}
