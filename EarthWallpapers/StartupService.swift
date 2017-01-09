//
//  StartupService.swift
//  EarthWallpapers
//
//  Created by Alessandro Maroso on 08/02/16.
//  Copyright © 2016 membersheep. All rights reserved.
//

import Cocoa

protocol StartupService {
    func applicationIsInStartUpItems() -> Bool
    func addApplicationToStartupItems()
    func removeApplicationFromStartupItems()
    func toggleLaunchAtStartup()
}

struct StartupServiceImpl: StartupService {
    
    func applicationIsInStartUpItems() -> Bool {
        return (getItemReferencesInLoginItems().existingReference != nil)
    }
    
    func addApplicationToStartupItems() {
        let itemReferences = getItemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            if shouldBeToggled {
                if let appUrl : CFURL = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL? {
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        itemReferences.lastReference,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                    print("Application was added to login items")
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                    print("Application was removed from login items")
                }
            }
        }
    }
    
    func removeApplicationFromStartupItems() {
        
    }
    
    fileprivate func getItemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        let itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.allocate(capacity: 1)
        if let appUrl : URL = URL(fileURLWithPath: Bundle.main.bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileList?
            if loginItemsRef != nil {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                print("There are \(loginItems.count) login items")
                let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
                for i in 0 ..< loginItems.count += 1 {
                    let currentItemRef: LSSharedFileListItem = loginItems.object(at: i)as! LSSharedFileListItemRef
                    if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                        if let urlRef: URL =  itemUrl.pointee?.takeRetainedValue() as URL? {
                            print("URL Ref: \(urlRef.lastPathComponent)")
                            if urlRef == appUrl {
                                return (currentItemRef, lastItemRef)
                            }
                        }
                    } else {
                        print("Unknown login application")
                    }
                }
                return (nil, lastItemRef)
            }
        }
        return (nil, nil)
    }
    
    func toggleLaunchAtStartup() {
        let itemReferences = getItemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            if shouldBeToggled {
                if let appUrl : CFURL = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL? {
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        itemReferences.lastReference,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                    print("Application was added to login items")
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                    print("Application was removed from login items")
                }
            }
        }
    }
}
