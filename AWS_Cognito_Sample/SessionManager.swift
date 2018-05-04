//
//  SessionManager.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/4/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import AWSCognitoIdentityProvider

final class SessionManager : NSObject {
    
    var window: UIWindow
    var signInViewController: SignInViewController?
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    
    override init() {
        self.window = UIApplication.shared.windows[0]
        super.init()
        // setup logging
        AWSDDLog.sharedInstance.logLevel = .verbose
        
        // setup service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
                                                                        clientSecret: CognitoIdentityUserPoolAppClientSecret,
                                                                        poolId: CognitoIdentityUserPoolId)
        
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // fetch the user pool client we initialized in above step
        let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        pool.delegate = self
    }
    
}

// MARK:- AWSCognitoIdentityInteractiveAuthenticationDelegate protocol delegate

extension SessionManager: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        if (self.navigationController == nil) {
            self.navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SignInNavigationController") as? UINavigationController
        }
        
        if (self.signInViewController == nil) {
            self.signInViewController = self.navigationController?.viewControllers[0] as? SignInViewController
        }
        
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            if (!self.navigationController!.isViewLoaded
                || self.navigationController!.view.window == nil) {
                self.window.rootViewController?.present(self.navigationController!,
                                                         animated: true,
                                                         completion: nil)
            }
            
        }
        return self.signInViewController!
    }
}
