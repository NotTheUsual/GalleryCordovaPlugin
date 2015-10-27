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
        galleryNavCtrl.initialIndex = index
        galleryNavCtrl.images = images
        
        viewController!.modalPresentationStyle = .CurrentContext
        navCtrl.modalPresentationStyle = .OverCurrentContext
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(navCtrl, animated: true, completion: nil)
    }
    
    func modalDidClose() {
        print("modal closed")
        sendPluginResponse("Closed normally")
        images = [MPImage]()
    }
    
    private func sendPluginResponse(response: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response)
        self.commandDelegate!.sendPluginResult(result, callbackId: command.callbackId)
    }
}
