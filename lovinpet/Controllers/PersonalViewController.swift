//
//  PersonalViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/18.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class PersonalViewController: UIViewController {
    var uid: String!

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        avatarImage.layer.masksToBounds = true
        avatarImage.backgroundColor = UIColor.white
        avatarImage.layer.borderColor = UIColor.gray.cgColor
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height / 2
        
        Database.database().reference().child(uid)
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
                    
                    self.avatarImage.kf.setImage(with: URL(string: dic["avatar"] as! String))
                }
            })
    }
}
