//
//  ScheduleViewControllerDelegate.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 14.12.2020.
//

import Foundation

protocol ScheduleViewDelegate {
    var courses: [Course] {get set}
    var selectedCourseIndex: Int! {get set}
    var scheduleView: ScheduleView! { get set }
    var location: (x: Int, y: Int) { get set }
    func addCourse(course: Course)
    func deleteSelectedCourse()
    func intersectsWithOtherCourses(course: Course) -> Course?
}
