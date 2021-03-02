//
//  Task.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import Foundation

struct Task: Codable {
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
    
    static func saveTasks(_ tasks: [[Task]]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedTasks = try? propertyListEncoder.encode(tasks)
        try? codedTasks?.write(to: ArchiveURL, options: .noFileProtection)
    }
    static func loadTasks() -> [[Task]]? {
        guard let codedTasks = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([[Task]].self, from: codedTasks)
    }
    
    var title: String
    var description: String
    var dueDate: Date
    var isCompleted: Bool
}
