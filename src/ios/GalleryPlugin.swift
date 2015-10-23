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
        
        // if let phoneNumbers = command.argumentAtIndex(0) as? [String],
        //    let countryCode = command.argumentAtIndex(1) as? String {
            
        //     commandDelegate!.runInBackground {
        //         self.numberFormatter = MPPhoneNumberFormatter(countryCode: countryCode)
                
        //         self.setupAddressBookWithCompletion { (addressBookRef) in
        //             if addressBookRef != nil {
        //                 let contacts = self.searchContactsForPhoneNumbers(phoneNumbers)
        //                 let responseArray = contacts.map { $0.dictionaryRepresentation }
        //                 self.sendPluginResponse(responseArray)
        //             } else {
        //                 self.sendPluginResponse(error: ["message": "AddressBook access denied"])
        //             }
        //         }
        //     }
        // } else {
        //     sendPluginResponse(error: ["message": "Not enough details provided"])
        // }
    } 
}
