//
//  LoginVIewController.swift
//  MeetUp
//
//  Created by Vipata Kilembo on 3/28/21.
//

import UIKit

class LoginVIewController: ViewController {
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBAction func userLogin(_ sender: Any) {
        let username = usernameField.text
        let password = PasswordField.text
        
        print(username!)
        print(password!)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
