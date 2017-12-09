//
//  CommentTableViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class CommentTableViewController: UITableViewController {
    var postId: String!
    let ref = Database.database().reference()
    var dataArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "Write", style: .done, target: self, action: #selector(commentClicked(_:)))
        self.navigationItem.rightBarButtonItem = item
        
        ref.child("comments").child(postId)
            .observe(.value, with: { (snapshot: DataSnapshot) in
                self.dataArray.removeAll()
                for item in snapshot.children {
                    let ele: DataSnapshot = item as! DataSnapshot
                    self.dataArray.append(ele.value as! String)
                }
                self.tableView.reloadData()
            })
    }
    
    @objc func commentClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "writeCommentViewController") as! WriteCommentViewController
        vc.postId = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        cell.setComment(comment: self.dataArray[indexPath.row])
        
        return cell
    }
}
