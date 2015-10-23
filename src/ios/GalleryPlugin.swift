//
//  GalleryPlugin.swift
//  GalleryPlugin
//
//  Created by James Hunter on 20/08/2015.
//  Copyright (c) 2015 JADH. All rights reserved.
//

import UIKit

@objc(GalleryPlugin) class GalleryPlugin : CDVPlugin {

    var command = CDVInvokedUrlCommand()

    func viewGallery(command: CDVInvokedUrlCommand) {
        self.command = command
        
        let storyboard = UIStoryboard(name: "GalleryStoryboard", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("galleryViewController") as! ModalViewController
        modalViewController.closeCallback = modalDidClose
        viewController!.modalPresentationStyle = .CurrentContext
        modalViewController.modalPresentationStyle = .OverCurrentContext
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    func modalDidClose() {
        print("modal closed")
        sendPluginResponse("Closed normally")
    }
    
    private func sendPluginResponse(response: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response)
        self.commandDelegate!.sendPluginResult(result, callbackId: command.callbackId)
    }
}
