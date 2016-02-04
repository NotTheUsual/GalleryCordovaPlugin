//
//  GalleryPlugin.swift
//  GalleryPlugin
//
//  Created by James Hunter on 20/08/2015.
//  Copyright (c) 2015 JADH. All rights reserved.
//

import UIKit

@objc(GalleryPlugin) class GalleryPlugin: CDVPlugin {

    var command = CDVInvokedUrlCommand()
    var images = [MPImage]()

    func viewGallery(command: CDVInvokedUrlCommand) {
        self.command = command

        let index = command.argumentAtIndex(1) as! Int
        let sourceImages = command.argumentAtIndex(0) as! [[String: AnyObject]]
        images = sourceImages.map { MPImage(dictionary: $0) }
        
        let storyboard = UIStoryboard(name: "GalleryStoryboard", bundle: nil)
        let navCtrl = storyboard.instantiateViewControllerWithIdentifier("galleryNavigationController") as! UINavigationController
        let galleryNavCtrl = navCtrl.childViewControllers[0] as! GalleryViewController
        galleryNavCtrl.closeCallback = modalDidClose
        galleryNavCtrl.deleteCallback = modalDidCloseToDeleteImageAtIndex
        galleryNavCtrl.initialIndex = index
        galleryNavCtrl.images = images
        
        var presentationStyle: UIModalPresentationStyle
        presentationStyle = .OverCurrentContext
        viewController!.modalPresentationStyle = presentationStyle
        navCtrl.modalPresentationStyle = presentationStyle
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(navCtrl, animated: true, completion: nil)
    }
    
    func modalDidClose() {
        sendPluginResponse(responseDict(.Normal, index: nil))
        images = [MPImage]()
    }
    
    func modalDidCloseToDeleteImageAtIndex(index: Int) {
        sendPluginResponse(responseDict(.Delete, index: index))
        images = [MPImage]()
    }
    
    private func sendPluginResponse(response: [String: AnyObject]) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: response)
        self.commandDelegate!.sendPluginResult(result, callbackId: command.callbackId)
    }
    
    private func responseDict(responseType: Response, index: Int?) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["action"] = responseType.rawValue
        if let index = index { dict["index"] = index }
        return dict
    }
    
    private enum Response: String {
        case Normal = "none"
        case Delete = "delete"
    }
}
