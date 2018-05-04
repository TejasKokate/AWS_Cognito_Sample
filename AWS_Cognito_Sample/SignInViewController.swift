//
//  SignInViewController.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/4/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SignInViewController: UIViewController {

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do sign in
        //        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: "tkokate@deloitte.com", password: "Pass@1234")
        //        self.passwordAuthenticationCompletion?.set(result: authDetails)
        //        
    }
}

extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
//            if (self.usernameText == nil) {
//                self.usernameText = authenticationInput.lastKnownUsername
//            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
//                self.username.text = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
