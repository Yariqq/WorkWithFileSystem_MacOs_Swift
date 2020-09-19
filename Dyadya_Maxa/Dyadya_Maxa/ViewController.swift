//
//  ViewController.swift
//  Dyadya_Maxa
//
//  Created by Ярослав Петюль on 9/7/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
    
    var namesList = [String]()
    var chosenDirectory: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func takeFilesFromDirectory() -> [String] {
        let rpDirectoryPicker: NSOpenPanel = NSOpenPanel()
        
        rpDirectoryPicker.allowsMultipleSelection = false
        rpDirectoryPicker.canChooseFiles = false
        rpDirectoryPicker.canChooseDirectories = true
        
        rpDirectoryPicker.runModal()
        
        chosenDirectory = rpDirectoryPicker.directoryURL
        
        var fList = [String]()
        
        if (chosenDirectory != nil) {
            
            let files = FileManager.default.enumerator(atPath: chosenDirectory!.path)
            
            while let file = files?.nextObject() {
                fList.append("\(file)")
            }
            //print(fList)
        }
        return fList
    }
    
    func sort() {
        var obrybki = Set<String>()
        var fullNames = [String]()
        
        for item in namesList {
            if item.contains("_") {
                let cutString = item.prefix(upTo: item.firstIndex(of: "_")!)
                if Int(cutString) != nil {
                    obrybki.insert(String(cutString))
                    fullNames.append(item)
                }
            }
        }
        
        for item in obrybki {
            let documentsDirectory = chosenDirectory?.path
            guard let encoded = documentsDirectory!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let docURL = URL(string: encoded) else { return }
            let dataPath = docURL.appendingPathComponent("\(item)")
            if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
                
                try! FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                
                for name in fullNames {
                    if name.contains(item){
                        try! FileManager.default.copyItem(atPath: documentsDirectory! + "/\(name)", toPath: documentsDirectory! + "/\(item)" + "/\(name)")
                        try! FileManager.default.removeItem(atPath: documentsDirectory! + "/\(name)")
                    }
                }
                
            }
        }
    }
    
    @IBAction func openButtonTapped(_ sender: Any) {
        namesList = takeFilesFromDirectory()
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        sort()
    }
    
    @IBAction func quitButtonTapped(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}

