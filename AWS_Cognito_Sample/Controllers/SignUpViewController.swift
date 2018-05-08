//
//  SignUpViewController.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/7/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController {

    //-------------------------------------------------------------------------
    // MARK: - IBOutlet
    //-------------------------------------------------------------------------
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    //-------------------------------------------------------------------------
    // MARK: - Variables
    //-------------------------------------------------------------------------
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    
    //-------------------------------------------------------------------------
    // MARK: - Lifecycle functions
    //-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signUpConfirmationViewController = segue.destination as? ConfirmSignUpViewController {
            signUpConfirmationViewController.sentTo = self.sentTo
            signUpConfirmationViewController.user = self.pool?.getUser(self.username.text!)
        }
    }
    
    //-------------------------------------------------------------------------
    // MARK: - User defined functions
    //-------------------------------------------------------------------------
    @IBAction func signUp(_ sender: AnyObject) {
        
        guard let userNameValue = self.username.text, !userNameValue.isEmpty,
            let passwordValue = self.password.text, !passwordValue.isEmpty else {
                let alertController = UIAlertController(title: "Missing Required Fields",
                                                        message: "Username / Password are required for registration.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:  nil)
                return
        }
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let phoneValue = self.phone.text, !phoneValue.isEmpty {
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = phoneValue
            if let phoneAttribute = phone {
                attributes.append(phoneAttribute)
            }
        }
        
        if let emailValue = self.email.text, !emailValue.isEmpty {
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = emailValue
            if let emailAttribute = email {
                attributes.append(emailAttribute)
            }
        }
        
        
            let picture = AWSCognitoIdentityUserAttributeType()
            picture?.name = "picture"
            picture?.value = ""
            if let pictureAttribute = picture {
                attributes.append(pictureAttribute)
            }
        
        
        if let emailValue = self.email.text, !emailValue.isEmpty {
            let name = AWSCognitoIdentityUserAttributeType()
            name?.name = "name"
            name?.value = emailValue
            if let nameAttribute = name {
                attributes.append(nameAttribute)
            }
        }
        
        //1
        let givenName = AWSCognitoIdentityUserAttributeType()
        givenName?.name = "given_name"
        givenName?.value = "givenname"
        if let given_name = givenName {
            attributes.append(given_name)
        }
        
        //2
        let familyName = AWSCognitoIdentityUserAttributeType()
        familyName?.name = "family_name"
        familyName?.value = "familyname"
        if let family_name = familyName {
            attributes.append(family_name)
        }
        
        //sign up the user
        self.pool?
            .signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil)
            .continueWith {[weak self] (task) -> Any? in
            
                guard let strongSelf = self else { return nil }
                
                DispatchQueue.main.async(execute: {
                    if let error = task.error as NSError? {
                        let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                message: error.userInfo["message"] as? String,
                                                                preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                        alertController.addAction(retryAction)
                        self?.present(alertController, animated: true, completion:  nil)
                    } else if let result = task.result  {
                        // handle the case where user has to confirm his identity via email / SMS
                        if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                            strongSelf.sentTo = result.codeDeliveryDetails?.destination
                            strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)
                        } else {
                            let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                })
                return nil
        }
    }
}
