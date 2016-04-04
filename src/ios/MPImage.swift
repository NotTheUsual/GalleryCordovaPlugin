//
//  MPImage.swift
//  CollectionGallery
//
//  Created by James Hunter on 23/10/2015.
//  Copyright © 2015 JADH. All rights reserved.
//

import UIKit

class MPImage: CustomStringConvertible {
    let src: String
    let caption: String
    let canDelete: Bool
    let canPin: Bool
    let pinned: Bool
    var view: UIImageView?
    
    var description: String {
        get {
            return "[src: \(src), caption: \(caption), canDelete: \(canDelete)]"
        }
    }
    
    init(name: String, caption: String, canDelete: Bool, canPin: Bool, pinned: Bool) {
        self.src = name
        self.caption = caption
        self.canDelete = canDelete
        self.canPin = canPin
        self.pinned = pinned
    }
    
    init(dictionary: [String:AnyObject]) {
        self.src = dictionary["src"] as! String
        self.caption = dictionary["caption"] as! String
        self.canDelete = dictionary["canDelete"] as! Bool
        self.canPin = dictionary["canPin"] as! Bool
        self.pinned = dictionary["pinned"] as! Bool
    }
}

extension MPImage: Equatable {}

func ==(lhs: MPImage, rhs: MPImage) -> Bool {
    return lhs.src == rhs.src && lhs.caption == rhs.caption
}
