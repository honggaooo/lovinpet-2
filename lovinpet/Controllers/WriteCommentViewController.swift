//
//  WriteCommentViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class WriteCommentViewController: UIViewController {

    @IBOutlet weak var commentLabel: UITextField!
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if commentLabel.text == nil {
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("comments").child(postId).childByAutoId().setValue(self.commentLabel.text) { (error, ref) in
            if error != nil {
                print("error: \(error!.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
