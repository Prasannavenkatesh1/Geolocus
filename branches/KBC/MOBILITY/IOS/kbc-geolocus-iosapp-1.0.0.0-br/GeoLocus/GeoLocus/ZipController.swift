//
//  ZipController.swift
//  GeoLocus
//
//  Created by khan on 25/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

/* Here the the final trip file which has trip data is created and zipped */

import Foundation
import Zip



public func createAndWriteToJsonFileForTripData(stringData: String?) throws -> NSURL? {
  
  var returnFilePath: NSURL?
  if let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
    
    if let documentDirectoryPath = NSURL(string: documentDirectory) {
      
      let filePath = documentDirectoryPath.URLByAppendingPathComponent(StringConstants.TRIP_FILE)
      let fileManager = NSFileManager.defaultManager()
      var isDirectory: ObjCBool = false
      
      if !fileManager.fileExistsAtPath(filePath.absoluteString, isDirectory: &isDirectory) {
        
        let createFile = fileManager.createFileAtPath(filePath.absoluteString, contents: nil, attributes: nil)
        if createFile {
          print("Final trip json file created")
        } else {throw FileHandlingError.FileCreationError}
        
      } else {
        print("File exists, get file path and store the data")
      }
      
      // Start writing JSON here
      
      if let stringData = stringData {
        let finalData = stringData.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let file = NSFileHandle(forWritingAtPath:filePath.absoluteString), finalData = finalData {
          
          file.writeData(finalData)
          returnFilePath = filePath
        } else { throw FileHandlingError.FileWriteError }
        
      }
      
    }
  }
  return returnFilePath
}

// Zip the Trip file

public func zipTripFile(filePath: NSURL?) -> NSURL? {
  
  var returnZipFilePath: NSURL?
  
  if let filePath = filePath {
    
    do {
      let zipFilePath = try Zip.quickZipFiles([filePath], fileName: "TripData")
      returnZipFilePath = zipFilePath
      
    }
    catch {
      
    }
  }
  
  return returnZipFilePath
}
