//
//  File.swift
//  FinalApp
//
//  Created by Айдана on 12/13/20.
//

import Foundation
import UIKit

struct Course: Codable {
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("courses").appendingPathExtension("plist")
    
    var name: String
    var instructor: String
    var location: String
    var type: String
    var day: Int
    var startTime: Int
    var color: Int
    var numberOfHours: Int
    
    func intersects(with course: Course) -> Bool{
        if self.day != course.day {
            return false
        }
        
        let rangeCourseOne = self.startTime..<(self.startTime + self.numberOfHours)
        let rangeCourseTwo = course.startTime..<(course.startTime + course.numberOfHours)
        
        return rangeCourseOne.overlaps(rangeCourseTwo)
    }
    
    static func saveCourses(courses: [Course]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedCourses = try? propertyListEncoder.encode(courses)
        try? codedCourses?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadCourses() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
}
