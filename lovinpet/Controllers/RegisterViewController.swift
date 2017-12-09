//
//  RegisterViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 10/8/17.
//  Copyright © 2017 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnRegister_TouchUpInside(_ sender: Any) {
        // TODO: perform some input validation here
        // check if the fields are not nil by using conditional binding
        if let email = txtEmail.text, let password = txtPassword.text //, let name = txtName.text
        {
            
            // Use the ample code from: https://firebase.google.com/docs/auth/ios/passwor-auth
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                // ...
            
                if user != nil{
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
                else{
                    // check error and show an error message
                    let alterController = UIAlertController(title: "Registration Failed!", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    
                    alterController.addAction(okAction)
                    self.present(alterController, animated: true, completion: nil)
                }
            }
        }
    }
    
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    txtEmail.resignFirstResponder()
    txtPassword.resignFirstResponder()
    txtName.resignFirstResponder()
}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
