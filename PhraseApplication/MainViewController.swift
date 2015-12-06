//
//  MainViewController.swift
//  PhraseApplication
//
//  Created by Eugen Waldschmidt on 03.12.15.
//  Copyright © 2015 Dynport GmbH. All rights reserved.
//
import Cocoa
import Foundation
import CoreData

class MainViewController: NSViewController, ProjectDelegate {
    
    var mainWindow = NSWindow()
    var projects:[Project] = []
    
    @IBOutlet weak var commandOutputMultilineLabel: NSTextField!
    @IBOutlet weak var cliPathLabel: NSTextField!
    @IBOutlet weak var cliPathSearchButton: NSButton!
    @IBOutlet weak var projectTableView: NSTableView!
    
    override func viewDidLoad() {
        if NSUserDefaults.standardUserDefaults().objectForKey("cliPath") != nil {
            cliPathLabel.stringValue = (NSUserDefaults.standardUserDefaults().objectForKey("cliPath") as? String)!
            
            if !((NSUserDefaults.standardUserDefaults().objectForKey("cliPath") as? String)!).isEmpty {
                self.cliPathSearchButton.enabled = false
            }
        }
        
        
        super.viewDidLoad()
        
        getAllProjects()
    }
    
    @IBAction func searchForCLIClient(sender: AnyObject) {
        CLIService().getCLIClient()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("cliPath") != nil {
            cliPathLabel.stringValue = (NSUserDefaults.standardUserDefaults().objectForKey("cliPath") as? String)!
        } else {
            cliPathLabel.stringValue = "Phrase App CLI not found."
        }
        
    }
    
    @IBAction func addProject(sender: AnyObject) {
        let projectSettingsViewController = ProjectSettingsViewController(nibName: "ProjectSettingsViewController", bundle: nil)!
        projectSettingsViewController.delegate = self
        self.presentViewControllerAsSheet(projectSettingsViewController)
    }
    
    @IBAction func removeProject(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Project")
        
        if self.projectTableView.selectedRow <= projects.count-1 {
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                
                for result in results {
                    let projectName = result.valueForKey("projectName") as! String
                    let projectLocation = result.valueForKey("projectPath") as! String
                    if projectName == projects[self.projectTableView.selectedRow].projectName && projectLocation == projects[self.projectTableView.selectedRow].projectLocation {
                        managedContext.deleteObject(result as! NSManagedObject)
                        
                        projects.removeAtIndex(self.projectTableView.selectedRow)
                        
                        do {
                            try managedContext.save()
                            projectTableView.reloadData()
                        } catch let saveError as NSError {
                            print(saveError)
                        }
                    }
                }
            } catch let error as NSError {
                print("nope \(error)")
            }
        }
    }
    
    func getAllProjects() {
        projects.removeAll()
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Project")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            
            for result in results {
                projects.append(Project(projectName: result.valueForKey("projectName") as! String, projectLocation: result.valueForKey("projectPath") as! String))
            }
        } catch let error as NSError {
            print("nope \(error)")
        }
    }
    
    func createProject() {
        getAllProjects()
        projectTableView.reloadData()
    }
    
    @IBAction func pushToProject(sender: AnyObject) {
        self.commandOutputMultilineLabel.stringValue = "--- Start pushing --- \n\n\(CLIService().pushLocale(getSelectedProject().projectLocation)) \n--- End of pushing ---"
    }
    
    @IBAction func pullFromProject(sender: AnyObject) {
                self.commandOutputMultilineLabel.stringValue = "--- Start pulling --- \n\n\(CLIService().pullLocale(getSelectedProject().projectLocation)) \n--- End of pulling ---"
    }
    
    func getSelectedProject() -> (projectName: String, projectLocation: String) {
        let selectedRow = self.projectTableView.selectedRow
        
        return (projects[selectedRow].projectName, projects[selectedRow].projectLocation)
    }
}
