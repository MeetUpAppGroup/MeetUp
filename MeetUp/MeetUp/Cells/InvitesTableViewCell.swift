//
//  InvitesTableViewCell.swift
//  MeetUp
//
//  Created by csuser on 4/8/21.
//

import UIKit
import Parse

class InvitesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var inviterImage: UIImageView!

    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    var objectId:String
        = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onAcceptButton(_ sender: Any) {
        let query = PFQuery(className: "invites")
        if(self.acceptButton.currentTitle == "Accept"){
            print("accepting")
            query.getObjectInBackground(withId: self.objectId){(invite:PFObject?, error:Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let invite = invite{
                    var current = invite["accepted"] as! Int
                    current+=1
                    invite["status"] = true
                    invite["accepted"] = current
                    
                    
                    if invite["acceptProfiles"] != nil {
                        var acceptProfileArr : [String] = invite["acceptProfiles"] as! [String]
                        if let index = acceptProfileArr.firstIndex(of: (PFUser.current()?.objectId!)!) {
                            print("user already accepted")
                            return
                        }
                        else {
                            acceptProfileArr.append((PFUser.current()?.objectId!)!)
                        }
                        
                        invite["acceptProfiles"] = acceptProfileArr
                    }
                    else {
                        var acceptProfileArr = [String]()
                        acceptProfileArr.append((PFUser.current()?.objectId!)!)
                        invite["acceptProfiles"] = acceptProfileArr
                    }
                    
                    invite.saveInBackground()
                    //self.sendNotification()
                    self.sendPushNotifications()
                    print("success")
                    self.acceptButton.setTitle("Cancel", for: .normal)
                }
            }
        }
        else if(self.acceptButton.currentTitle == "Cancel"){
            print("canceling")
            query.getObjectInBackground(withId: self.objectId){(invite:PFObject?, error:Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let invite = invite{
                    var current = invite["accepted"] as! Int
                    current-=1
                    invite["status"] = false
                    invite["accepted"] = current
                    
                    if invite["acceptProfiles"] != nil {
                        var acceptProfileArr: [String] = invite["acceptProfiles"] as! [String]
                        if let index = acceptProfileArr.firstIndex(of: (PFUser.current()?.objectId!)!) {
                            acceptProfileArr.remove(at: index)
                        }
                        invite["acceptProfiles"] = acceptProfileArr
                    }
                    
                    invite.saveInBackground()
                    print("success")
                    self.acceptButton.setTitle("Accept", for: .normal)
                }
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func sendNotification(){
        print("sending notification")
        let push = PFPush()
        let username = PFUser.current()?["username"] as! String
        print(username)
         push.setChannel("accepts")
         push.setMessage("\(username) accepted your invite!")
         push.sendInBackground()
    }
    
    func sendPushNotifications() {
//         let cloudParams : [AnyHashable:String] = [:]
//         PFCloud.callFunction(inBackground: "pushsample", withParameters: cloudParams, block: {
//             (result: Any?, error: Error?) -> Void in
//             if error != nil {
//                 if let descrip = error?.localizedDescription{
//                     print(descrip)
//                 }
//             }else{
//                 print(result as! String)
//             }
//         })
        
        let cloudParams : [AnyHashable:String] = [:]
                PFCloud.callFunction(inBackground: "sendPushToAllUsers", withParameters: cloudParams, block: {
                    (result: Any?, error: Error?) -> Void in
                    if error != nil {
                        if let descrip = error?.localizedDescription{
                            print(descrip)
                        }else{
                            print("error")
                        }
                    }else{
                        print("Success Finally")
                    }
                })
    
    }
}
