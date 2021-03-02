//
//  AddEditCourseViewController.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 14.12.2020.
//

import UIKit

class AddEditCourseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var editExistingCourse = false
    
    var selectedColor: Int = 0
    
    var courseTypePickerData = ["Lecture", "Practice", "Labaratory"]
    var weekDayPickerData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var startTimePickerData = ["9am", "10am", "11am", "12am", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm"]
    var endTimePickerData = ["10am", "11am", "12am", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm"]
    
    var colors: [Int: UIColor] = [0: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), 1: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), 2: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), 3: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), 4: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), 5: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), 6: #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)]
    
    var scheduleViewDelegate: ScheduleViewDelegate!
    
    @IBOutlet weak var courseNameTextField: UITextField!
    
    @IBOutlet weak var courseInstructorTextField: UITextField!
    
    @IBOutlet weak var courseLocationTextField: UITextField!
    
    @IBOutlet var courseTypeSegmentedControl: UISegmentedControl!

    @IBOutlet var weekDaySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startTimePicker: UIPickerView!
    
    @IBOutlet weak var endTimePicker: UIPickerView!
    
    
    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var addSaveButton: UIButton!
    
    
    fileprivate func addSpecifiedCourse() -> Bool {
        let courseName = courseNameTextField.text ?? ""
        let courseInstructor = courseInstructorTextField.text ?? ""
        let courseLocation = courseLocationTextField.text ?? ""
        
        let courseType = courseTypePickerData[courseTypeSegmentedControl.selectedSegmentIndex]
        let weekDay = weekDaySegmentedControl.selectedSegmentIndex
        
        let startTime = startTimePicker.selectedRow(inComponent: 0)
        let endTime = endTimePicker.selectedRow(inComponent: 0)
        let numberOfHours =  endTime - startTime + 1
        
        let course = Course(name: courseName, instructor: courseInstructor, location: courseLocation, type: courseType, day: weekDay, startTime: startTime, color: selectedColor, numberOfHours: numberOfHours)
        
        
        if endTime < startTime {
            self.showMessage(title: "Incorrect time", message: "Start time cannot be later than or equal to the end time")
            return false
        }
        else if let intersectingCourse = scheduleViewDelegate.intersectsWithOtherCourses(course: course) {
            self.showMessage(title: "Intersection", message: "Selected time is intersecting with course \(intersectingCourse.name)")
            
            return false
        }
        else {
            scheduleViewDelegate.addCourse(course: course)
        }
        
        return true
    }
    
    func selectButton(sender: UIButton) {
        
        selectedColor = colorButtons.firstIndex(where: {$0 == sender}) ?? 0
        
        sender.layer.borderWidth = 2.5
        sender.layer.borderColor = UIColor.white.cgColor
        
        for button in colorButtons {
            if button != sender {
                button.layer.borderWidth = 0.0
            }
        }

    }
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        selectButton(sender: sender)
        
                
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if !editExistingCourse && addSpecifiedCourse() {
            navigationController?.popViewController(animated: true)
        } else if editExistingCourse {
            let removedCourse = scheduleViewDelegate.courses.remove(at: scheduleViewDelegate.selectedCourseIndex)
            
            if !addSpecifiedCourse() {
                scheduleViewDelegate.addCourse(course: removedCourse)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteBarButtonItemPressed(_ sender: UIBarButtonItem) {
        
        scheduleViewDelegate.deleteSelectedCourse()
        navigationController?.popViewController(animated: true)
    }
    
    
    func showMessage(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (buttoon)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
        }
        alert.addAction(ok)
        // show the alert
        self.parentViewController!.present(alert, animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case startTimePicker:
            return startTimePickerData.count
        case endTimePicker:
            return endTimePickerData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case startTimePicker:
            return startTimePickerData[row]
        case endTimePicker:
            return endTimePickerData[row]
        default:
            return "??"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        addSaveButton.layer.cornerRadius = 8.0
        
        weekDaySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        courseTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    
        self.startTimePicker.delegate = self
        self.endTimePicker.delegate = self
        self.startTimePicker.dataSource = self
        self.endTimePicker.dataSource = self
        
        
        if !editExistingCourse {
            
            navigationItem.title = "Add Course"
            weekDaySegmentedControl.selectedSegmentIndex = scheduleViewDelegate.location.x
            startTimePicker.selectRow(scheduleViewDelegate.location.y, inComponent: 0, animated: true)
            endTimePicker.selectRow(scheduleViewDelegate.location.y, inComponent: 0, animated: true)
            deleteBarButtonItem.isEnabled = true
            self.navigationItem.rightBarButtonItem = nil
            
            addSaveButton.setTitle("Add", for: .normal)
            selectButton(sender: colorButtons[0])
        }
        else {
            
            self.navigationItem.rightBarButtonItem = deleteBarButtonItem
            addSaveButton.setTitle("Save", for: .normal)

            let course = scheduleViewDelegate.courses[scheduleViewDelegate.selectedCourseIndex]
            
            navigationItem.title = course.name.isEmpty ? "Course" : course.name
            
            courseNameTextField.text = course.name
            courseInstructorTextField.text = course.instructor
            courseLocationTextField.text = course.location
            
            
            for index in colorButtons.indices {
                
                if index == course.color {
                    selectButton(sender: colorButtons[index])
                }
            }

            courseTypeSegmentedControl.selectedSegmentIndex = courseTypePickerData.firstIndex(of: course.type) ?? 2
            weekDaySegmentedControl.selectedSegmentIndex = course.day
            startTimePicker.selectRow(course.startTime, inComponent: 0, animated: true)
            endTimePicker.selectRow(course.startTime + course.numberOfHours - 1, inComponent: 0, animated: true)
            
            
            
        }
        
        for index in colorButtons.indices {
            let button = colorButtons[index]
            button.layer.backgroundColor = colors[index]?.cgColor
            button.layer.cornerRadius = button.frame.width / 2
            
        }
        
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
