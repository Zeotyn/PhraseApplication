import Foundation
import Cocoa

extension MainViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.projects.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "projectName" {
            cellView.textField!.stringValue = projects[row].projectName
            return cellView
        }
        
        if tableColumn!.identifier == "projectPath" {
            cellView.textField!.stringValue = projects[row].projectLocation
        }
        
        return cellView
    }
}

extension MainViewController: NSTableViewDelegate {
    
}