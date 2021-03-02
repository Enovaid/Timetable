//
//  Lines.swift
//  FinalApp
//
//  Created by Айдана on 12/12/20.
//

import UIKit

class ScheduleView: UIView {
    
    var colors: [Int: UIColor] = [0: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), 1: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), 2: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), 3: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), 4: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), 5: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), 6: #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)]
    
    var courseLabelFont: UIFont = .boldSystemFont(ofSize: 14.0)
    var courseTypeLabelFont: UIFont = .italicSystemFont(ofSize: 12.0)
    var locationLabelFont: UIFont = .boldSystemFont(ofSize: 13.0)
    
    var startXPoint: CGFloat = 45.0
    var startYPoint: CGFloat = 0
    var endYPoint: CGFloat = 20.0
    
    lazy var linesBoundsWidth = bounds.width - startXPoint
    lazy var linesBoundsHeight = bounds.height - startYPoint - endYPoint
    
    lazy var cellWidth = linesBoundsWidth/5
    lazy var cellHeight: CGFloat = linesBoundsHeight/12.0
    
    
    var line = UIBezierPath()
    
    var viewInterSected: Bool = false
    var currentRectangle: UIView?
    var rectangles: Dictionary<UIView, Course> = [:]
    
    func graph(){
        
        //Horizontal Lines
        for i in 1...11 {
            line.move(to: .init(x: startXPoint, y: cellHeight * CGFloat(i) ))
            line.addLine(to: .init(x: bounds.width, y:  cellHeight * CGFloat(i) ))
        }
    
        //Vertical Lines
        for i in 1...4 {
            line.move(to: .init(x: cellWidth * CGFloat(i) + startXPoint, y: startYPoint))
            line.addLine(to: .init(x: cellWidth * CGFloat(i) + startXPoint, y: bounds.height * 0.975))
        }
        
        // Stroke setup
        UIColor.gray.setStroke()
        line.lineWidth = 0.2
        line.stroke()
    }
    
    
    fileprivate func createNewRectangleWith(rectangleXCoordinate: CGFloat, rectangleYCoordinate: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat, color: UIColor) -> UIView {
        
        let rectangle = UIView(frame: CGRect(x: rectangleXCoordinate, y: rectangleYCoordinate, width: cellWidth, height: cellHeight-0.1))
        
        //Set the style of rectangle
        rectangle.backgroundColor = color
        rectangle.layer.cornerRadius = 6
        rectangle.layer.borderWidth = 2
        
        return rectangle
    }
    
    fileprivate func createLabel(text: String, font: UIFont, numberOfLines: Int = 1, textColor: UIColor) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        // TODO: Change the static values to variables
        // Setup a course label
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        
        return label
    }
    
    func addCourseCell(course: Course) {
        
        // Get the location of the cell
        let x = course.day
        let y = course.startTime
        
        // Set the coordinates of rectangle to be added
        let rectangleXCoordinate: CGFloat = startXPoint + CGFloat(x) * cellWidth
        let rectangleYCoordinate: CGFloat = startYPoint + CGFloat(y) * cellHeight
        
        // Create the rectangle
        let rectangle = createNewRectangleWith(rectangleXCoordinate: rectangleXCoordinate, rectangleYCoordinate: rectangleYCoordinate, cellWidth: cellWidth, cellHeight: cellHeight * CGFloat(course.numberOfHours), color: colors[course.color] ?? UIColor.darkGray)

            // Create a course label
        let courseLabel = createLabel(text: course.name, font: courseLabelFont, numberOfLines: 2, textColor: .white)
            
            // Add course label
        rectangle.addSubview(courseLabel)
            
            // Setup Course label constraints
        courseLabel.translatesAutoresizingMaskIntoConstraints = false
        courseLabel.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: 5).isActive = true
        courseLabel.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: 5).isActive = true
        courseLabel.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -5).isActive = true

            // Create a course type label
        let courseTypeLabel = createLabel(text: course.type, font: courseTypeLabelFont, textColor: .white)
            
            // Add course type label
        rectangle.addSubview(courseTypeLabel)
            
            // Setup Course Type label constraints
        courseTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        courseTypeLabel.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: 5.0).isActive = true
        courseTypeLabel.topAnchor.constraint(equalTo: courseLabel.bottomAnchor, constant: 5.0).isActive = true
        courseTypeLabel.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -5.0).isActive = true
            
            // Create Classroom Label
        let locationLabel = createLabel(text: course.location, font: locationLabelFont, textColor: .white)
            
            // Add Classroom Label
        rectangle.addSubview(locationLabel)
            
            // Setup Classroom Label constraints
        locationLabel.textAlignment = .right
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: 5.0).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -5.0).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -5.0).isActive = true
        
        
        rectangle.isUserInteractionEnabled = true
        rectangles[rectangle] = course
        self.addSubview(rectangle)

    }

   
    @objc func rectangleTapped(_ sender: UITapGestureRecognizer) {
        print(rectangles[sender.view!]!.name)
        
        
    }
    
    func getCellLocation(from point: CGPoint) -> (x: Int, y: Int) {
        
        let x = Int(point.x - startXPoint)/Int(cellWidth)
        let y = Int(point.y - startYPoint - endYPoint)/Int(cellHeight)
        
        return (x, y)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        graph()
    }
   

}


extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
