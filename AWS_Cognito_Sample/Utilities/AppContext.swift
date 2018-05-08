//
//  AppContext.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/4/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import Foundation

public class AppContext {
    
    //-------------------------------------------------------------------------
    // MARK: - Variables
    //-------------------------------------------------------------------------
    public static var currentContext: AppContext = AppContext()
    var sessionManager : SessionManager
    
    //-------------------------------------------------------------------------
    // MARK: - Initializer
    //-------------------------------------------------------------------------
    fileprivate init() {
        sessionManager = SessionManager.init()
    }
}
