//
//  ErrorHandler.swift
//  GeoLocus
//
//  Created by khan on 18/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

enum LoginError: ErrorType {
    
    case InvalidLoginCredentials
    var description: String {
        switch self {
        case .InvalidLoginCredentials:
                return "Invalid login credentials"
        }
    }
}

enum NetworkError: ErrorType {
    case UnexpectedServerError
    case SessionTimedOut
    case NetworkUnreachable
    
}