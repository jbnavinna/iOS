//
//  NotificationVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

class NotificationVC: UIViewController{

    @IBOutlet weak var tblNotification: UITableView!
    
    var notificationData : [Notification] = []
    
    var notiftitle=""
    var notifsummary=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.register(UINib(nibName: "CellNews", bundle: nil), forCellReuseIdentifier: "resuableNewsCell")
        fetchNotificationData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchNotificationData() {
        let rtDBRef = Database.database().reference()
        var initialRead = true
        notificationData.removeAll()
        rtDBRef.child("notifications").observe(.childAdded, with: {
            snapshot in
            if initialRead == false {
                if let dict = snapshot.value as? [String : Any] {
                    for data in dict {
                        guard let innerData = data.value as? [String : Any] else{
                            continue
                        }
                        
                        self.notificationData.append(Notification(title: innerData["title"] as! String, content: innerData["content"] as! String))
                    }
                    self.tblNotification.reloadData()
                }
            }
        })
        
        rtDBRef.child("notifications").observeSingleEvent(of: .value, with: {
            snapshot in
            initialRead = false
            
            if let dict = snapshot.value as? [String : Any] {
                for data in dict {
                    guard let innerData = data.value as? [String : Any] else{
                        continue
                    }
                    
                    self.notificationData.append(Notification(title: innerData["title"] as! String, content: innerData["content"] as! String))
                }
                self.tblNotification.reloadData()
            }
        })
    }
}

extension NotificationVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "resuableNewsCell", for: indexPath) as! CellNews
        cell.configureCell(title: notificationData[indexPath.row].title, content: notificationData[indexPath.row].content)
        return cell
    }
}

extension NotificationVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: notificationData[indexPath.row].title, message: notificationData[indexPath.row].content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert , animated: true)
    }
}
