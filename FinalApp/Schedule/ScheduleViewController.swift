//
//  ScheduleViewController.swift
//  FinalApp
//
//  Created by Айдана on 12/11/20.
//

import UIKit

class ScheduleViewController: UIViewController, ScheduleViewDelegate {
    
    
    var selectedCourseIndex: Int!
    
    
    
    func addCourse(course: Course) {
        courses.append(course)
        Course.saveCourses(courses: courses)
        
        updateSchedule()
    }
    
    func deleteSelectedCourse() {
        courses.remove(at: selectedCourseIndex)
        Course.saveCourses(courses: courses)
        
        updateSchedule()
    }
    
    func updateSchedule() {
        
        for subview in scheduleView.subviews {
            if subview is UIStackView {
                continue
            }
            else {
                subview.removeFromSuperview()
            }
            
        }
        
        for course in courses { scheduleView.addCourseCell(course: course)}
    }
    
    
    var courses = [Course]()
    
    @IBOutlet weak var scheduleView: ScheduleView!
    
    var location = (x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedCourses = Course.loadCourses() {
            courses = loadedCourses
            updateSchedule()
        }
        
        addGesture()
    }
    
    func intersectsWithOtherCourses(course courseToCheck: Course) -> Course? {
        for course in courses {
            if course.intersects(with: courseToCheck) {
                return course
            }
        }
        return nil
    }
    
    func indexOfCourseInCell(location: (x: Int, y: Int)) -> Int? {
        for index in courses.indices {
            let course = courses[index]
            let courseTimeRange = course.startTime..<(course.startTime + course.numberOfHours)
            
            if location.x == course.day && courseTimeRange.contains(location.y) {
                return index
            }
        }
        return nil
    }
    
    func addGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        scheduleView.addGestureRecognizer(tapGesture)
        scheduleView.isUserInteractionEnabled = true
    }
    
    
    var x: Double?
    var y: Double?
    var tapGesture = UITapGestureRecognizer()
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: scheduleView)
        location = scheduleView.getCellLocation(from: point)
        
        if let selectedCourseIndex = indexOfCourseInCell(location: location) {
            self.selectedCourseIndex = selectedCourseIndex
            performSegue(withIdentifier: "EditExistingCourse", sender: self)
        }
        else {
            performSegue(withIdentifier: "AddNewCourse", sender: self)
        }
        
        print("x: \(location.x), y:\(location.y)")
    
    }
    
    @IBAction func addCourseBarButtonItemPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "AddNewCourse", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddNewCourse" || segue.identifier == "EditExistingCourse" {
            
            let addEditCourseViewController = segue.destination as! AddEditCourseViewController
            addEditCourseViewController.scheduleViewDelegate = self
            
            if segue.identifier == "EditExistingCourse" {
                addEditCourseViewController.editExistingCourse = true
            } else if segue.identifier == "AddNewCourse" {
                addEditCourseViewController.editExistingCourse = false
            }
        }
    }

}
