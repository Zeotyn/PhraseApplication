//
//  ProjectSettingsViewController.swift
//  PhraseApplication
//
//  Created by Eugen Waldschmidt on 03.12.15.
//  Copyright © 2015 Dynport GmbH. All rights reserved.
//


import Cocoa
import Foundation
import CoreData

class ProjectSettingsViewController: NSViewController {
    
    @IBOutlet weak var projectNameTextField: NSTextField!
    @IBOutlet weak var sourcePathTextField: NSTextField!
    
    var delegate:ProjectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveProject(sender: AnyObject) {
        self.createProject(self.projectNameTextField.stringValue, projectPath: self.sourcePathTextField.stringValue)
        self.dismissController(sender)
    }
    
    @IBAction func getProjectSource(sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let exportedFileURL = openPanel.URL
                
                self.sourcePathTextField.stringValue = exportedFileURL!.path!
            }
        }
        
    }
    
    @IBAction func closeDialog(sender: AnyObject) {
        self.dismissController(sender)
    }
    
    func createProject(projectName: String, projectPath: String) {
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Project", inManagedObjectContext: managedContext)
        
        let project = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        project.setValue(projectName, forKey: "projectName")
        project.setValue(projectPath, forKey: "projectPath")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.delegate?.createProject()
    }
}

protocol ProjectDelegate {
    func createProject()
}
