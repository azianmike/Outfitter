//
//  Global.swift
//  Outfitter
//
//  Created by Ian Eckles on 4/22/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import Foundation

class Global{
    class func mergeLists(inout listToMergeInto: [PFObject], listToMerge: [PFObject]){
        NSLog("Running mergeLists")
        for object in listToMerge {
            listToMergeInto.append(object)
        }
    }
    class func mergeLists(inout listToMergeInto: [PFObject]!, listToMerge: [PFObject]){
        NSLog("Running mergeLists")
        for object in listToMerge {
            listToMergeInto.append(object)
        }
    }
}