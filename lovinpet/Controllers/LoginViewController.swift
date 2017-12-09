//
//  LoginViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 10/8/17.
//  Copyright © 2017 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnLogin_TouchUpInside(_ sender: Any) {
        
        if let email = userNameTextField.text, let password = txtPassword.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // ...
                if user != nil {
                    Global.sharedInstance.user = user
                    Database.database().reference().child(Global.sharedInstance.user.uid)
                        .observe(.value, with: { (snapshot: DataSnapshot) in
                            if snapshot.value != nil && !(snapshot.value is NSNull) {
                                let dic = snapshot.value as! [String: AnyObject]
                                Global.sharedInstance.age = dic["age"] as! String
                                Global.sharedInstance.avatar = dic["avatar"] as! String
                                Global.sharedInstance.breed = dic["breed"] as! String
                                Global.sharedInstance.gender = dic["gender"] as! String
                                Global.sharedInstance.nickname = dic["name"] as! String
                                
                            }
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                            self.present(vc!, animated: true, completion: nil)
                        })
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
