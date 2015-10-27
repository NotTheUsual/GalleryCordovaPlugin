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
    var view: UIImageView?
    
    var description: String {
        get {
            return "[src: \(src), caption: \(caption), canDelete: \(canDelete)]"
        }
    }
    
    init(name: String, caption: String, canDelete: Bool) {
        self.src = name
        self.caption = caption
        self.canDelete = canDelete
    }
    
    init(dictionary: [String:AnyObject]) {
        self.src = dictionary["src"] as! String
        self.caption = dictionary["caption"] as! String
        self.canDelete = dictionary["canDelete"] as! Bool
    }
}

extension MPImage: Equatable {}

func ==(lhs: MPImage, rhs: MPImage) -> Bool {
    return lhs.src == rhs.src && lhs.caption == rhs.caption
}
