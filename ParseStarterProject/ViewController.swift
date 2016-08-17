/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func voltar(sender: AnyObject) {
        performSegueWithIdentifier("principal2", sender: self)
        
    }
    var signUpState = false

    @IBAction func login(sender: AnyObject) {
        if signUpState == true {
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            taggleSignupButton.setTitle("Switch to signup", forState: UIControlState.Normal)
            signUpState = false
            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
            
        } else {
            
            signUpButton.setTitle("Sign up", forState: UIControlState.Normal)
            taggleSignupButton.setTitle("Switch to login", forState: UIControlState.Normal)
            signUpState = true
            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1
            
        }

        
    }
    
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    
    
    
    @available(iOS 8.0, *)
    @IBAction func signUp(sender: AnyObject) {
        if username.text == "" || password.text == ""{
            displayAlert("Campos em branco", message: "Utilizador e Password requeridos")
            
        }else{
           
            
            if signUpState == true {
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                user["isDriver"] = `switch`.on
                
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        if let errorString = error.userInfo["error"] as? String {
                            // Show the errorString somewhere and let the user try again.
                            self.displayAlert("Sign Up Failed", message: errorString)
                            
                            
                        }
                        
                        
                    }else {
                        if self.`switch`.on == true {
                            
                            self.performSegueWithIdentifier("loginDriver", sender: self)
                            
                        }else{
                            
                            
                        self.performSegueWithIdentifier("loginRider", sender: self)
                        
                        }
                        
                    
                    
                    
                    }
                }
            }else{
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!){(user: PFUser?, error: NSError?) -> Void in
                
                    if let user = user {
                        
                        if user["isDriver"]! as! Bool == true {
                            
                            self.performSegueWithIdentifier("loginDriver", sender: self)
                            
                        }else{
                            
                            
                            self.performSegueWithIdentifier("loginRider", sender: self)
                            
                        }

                        
                        
                        
                        
                    } else {
                       
                            if let errorString = error!.userInfo["error"] as? String {
                                // Show the errorString somewhere and let the user try again.
                                self.displayAlert("Login Failed", message: errorString)
                                
                                
                
                            
                            
                        }
                    }
                    

                
                
                }
                
            
            }
            
        
        
        }
    }
    
    
    @IBAction func switchToLogin(sender: AnyObject) {
       
    }
    
    
    @IBOutlet weak var taggleSignupButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var or: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Controlar o botão
        signUpButton.setTitle("Entrar", forState: UIControlState.Normal)
        //taggleSignupButton.setTitle("Switch to signup", forState: UIControlState.Normal)
        signUpState = false
        riderLabel.alpha = 0
        driverLabel.alpha = 0
        `switch`.alpha = 0
        
        taggleSignupButton.alpha = 0
        or.alpha = 0
        
        // Do any additional setup after loading the view, typically from a nib.
        signUpState = false
      
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.username.delegate = self
        self.password.delegate = self
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        print("Usuario corrente\(PFUser.currentUser())")
        if PFUser.currentUser()?.username != nil{
            
          print("Usuario corrente\(PFUser.currentUser())")
            if PFUser.currentUser()?["isDriver"]! as! Bool == true {
                
                self.performSegueWithIdentifier("loginDriver", sender: self)
                
            }else{
                
                
                self.performSegueWithIdentifier("loginRider", sender: self)
                
            }

        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
