//
//  FirstViewController.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/4/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import AWSCognitoIdentityProvider

class FirstViewController: UIViewController {

    //-------------------------------------------------------------------------
    // MARK: - IBOutlet
    //-------------------------------------------------------------------------
    @IBOutlet weak var tableView: UITableView!

    //-------------------------------------------------------------------------
    // MARK: - Variables
    //-------------------------------------------------------------------------
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    
    //-------------------------------------------------------------------------
    // MARK: - Lifecycle functions
    //-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        self.refresh()
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    //-------------------------------------------------------------------------
    // MARK: - User defined functions
    //-------------------------------------------------------------------------
    @IBAction func signOut(_ sender: AnyObject) {
        self.user?.signOut()
        self.title = nil
        self.response = nil
        self.tableView.reloadData()
        self.refresh()
    }
    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.title = self.user?.username
                
                //To get the Token information from session
                self.user?.getSession().continueOnSuccessWith(block: { (task) -> Any? in
                    //AWSCognitoIdentityUserSession
                    let idToken = task.result?.idToken?.tokenString
                    let accessToken = task.result?.accessToken?.tokenString
                    let refreshToken = task.result?.refreshToken?.tokenString
                    let expirationTime = task.result?.expirationTime
                    if let idToken = idToken {
                        print("***** Id Token = \(idToken))")
                    }
                    if let accessToken = accessToken {
                        print("***** Access Token = \(accessToken))")
                    }
                    if let refreshToken = refreshToken {
                        print("***** Refresh Token = \(refreshToken))")
                    }
                    if let expirationTime = expirationTime {
                        print("***** Expiration Token = \(expirationTime))")
                    }
                    return nil
                })
                self.tableView.reloadData()
            })
            return nil
        }
    }
}

//-------------------------------------------------------------------------
// MARK: - Tableview Delegate
//-------------------------------------------------------------------------

extension FirstViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = self.response  {
            return response.userAttributes!.count
        }
        return 0
    }
}

//-------------------------------------------------------------------------
// MARK: - Tableview Datasource
//-------------------------------------------------------------------------

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userAttributesCell", for: indexPath)
        let userAttribute = self.response?.userAttributes![indexPath.row]
        cell.textLabel!.text = userAttribute?.name
        cell.detailTextLabel!.text = userAttribute?.value
        return cell
    }
}
