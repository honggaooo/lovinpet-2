//
//  FeedTableViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController, CommentProtocal {
    let ref = Database.database().reference()
    var dataArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("posts")
            .observe(.value, with: { (snapshot: DataSnapshot) in
                self.dataArray.removeAll()
                for item in snapshot.children {
                    let ele: DataSnapshot = item as! DataSnapshot
                    var snapshotValue = ele.value as! [String: String]
                    snapshotValue["id"] = ele.key
                    
                    self.dataArray.append(snapshotValue)
                }
                self.tableView.reloadData()
            })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell

        let item = dataArray[indexPath.row]
        
        cell.set(avatar: item["avatar"] as! String, image: item["image"] as! String, title: item["title"] as! String, nickname: item["nickname"] as! String)
        cell.postId = item["id"] as! String
        cell.commentProtocal = self

        return cell
    }
    
    func gotoComment(postId: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "commentViewController") as! CommentTableViewController
        vc.postId = postId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataArray[indexPath.row]
        
        let uid = item["uid"] as! String
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalViewController") as! PersonalViewController
        vc.uid = uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
