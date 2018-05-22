//
//  Lesson.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation

class Lesson {
    var lessonNr : Int
    var attendance = [String: Bool]()
    
    init(lessonNr: Int, listOfStudents: [Student]) {
        self.lessonNr = lessonNr
        
        for student in listOfStudents {
            attendance[student.studentId] = false
        }
    }
    
    
    func toJSONString() -> String {
        var JSONString = "{\"LessonNr\": \(lessonNr), \"attendance\" : {"
        var c = 0
        for element in attendance {
            JSONString.append("\"\(element.key)\": \(element.value)")
            if c != attendance.count-1 {
                JSONString.append(",")
            } else {
                JSONString.append("}}")
            }
            c += 1
        }
        return JSONString
    }
    
    
}
