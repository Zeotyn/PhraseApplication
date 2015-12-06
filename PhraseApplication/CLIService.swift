import Foundation

class CLIService {
    
    // TODO: later create project
    
    func getCLIClient() {
        let guesses = ["/usr/local/bin/phraseapp", "~/bin/phraseapp"]
        var finalPath:String?
        
        for guess in guesses {
            if NSFileManager.defaultManager().isExecutableFileAtPath(guess) {
                finalPath = guess
                break
            }
        }
        
        // TODO: Alertmodal view.
        if finalPath == nil {
            print("Something went wrong, dude!")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(finalPath, forKey: "cliPath")
    }
    
    
    func pushLocale(projectURL:String) -> String {
        if !projectURL.isEmpty {
            return self.runTask(projectURL, arguments: ["push"])
        } else {
            return "There is something wrong with your project Location"
        }
    }
    
    func pullLocale(projectURL:String) -> String {
        if !projectURL.isEmpty {
            return self.runTask(projectURL, arguments: ["pull"])
        } else {
            return "There is something wrong with your project Location"
        }
    }
    
    func runTask(currentPath: String, arguments: [String]) -> String {
        let cliTask = NSTask()
        cliTask.currentDirectoryPath = "\(currentPath)"
        cliTask.launchPath = (NSUserDefaults.standardUserDefaults().objectForKey("cliPath") as? String)!
        cliTask.arguments = arguments
        let pipe = NSPipe()
        cliTask.standardOutput = pipe
        cliTask.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: NSUTF8StringEncoding)
        cliTask.waitUntilExit()
        
        return output!
    }
    
}