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
                return ErrorConstants.InvalidLogin  // PLEASE USE GLOBAL CONSTANTS FOR STRING DECLARATION
        }
    }
}

enum NetworkError: ErrorType {
    case UnexpectedServerError
    case SessionTimedOut
    case NetworkUnreachable
    
}

enum FileHandlingError: ErrorType {
  
  case FileCreationError
  case FileReadError
  case FileWriteError
  case InvalidFileError
  case NSError
  
  var description: String {
    switch self {
      
    case .FileCreationError:
      return ErrorConstants.FILE_CREATE_ERROR
      
    case .FileReadError:
      return ErrorConstants.FILE_READ_ERROR
    case .FileWriteError:
      return ErrorConstants.FILE_WRITE_ERROR
      
    case .InvalidFileError:
      
      return ErrorConstants.FILE_INVALID_ERROR
      
    default:
      return "Unknown error"
      
      
    }
  }
}
