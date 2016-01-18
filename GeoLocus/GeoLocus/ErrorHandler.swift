//
//  ErrorHandler.swift
//  GeoLocus
//
//  Created by khan on 18/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//



//DECLARE ALL ERROR PATTERN MATCHINGS HERE

import Foundation

enum LoginError: ErrorType {
    
    case InvalidLoginCredentials
    var description: String {
        switch self {
        case .InvalidLoginCredentials:
                return "Invalid login credentials"  // PLEASE USE GLOBAL CONSTANTS FOR STRING DECLARATION
        }
    }
}

enum NetworkError: ErrorType {
    case UnexpectedServerError
    case SessionTimedOut
    case NetworkUnreachable
    
}