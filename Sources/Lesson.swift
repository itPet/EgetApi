//
//  Lesson.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation

class Lesson: Codable {
    var lessonNr : Int
    var attendance = [String: Bool]()
    
    init(lessonNr: Int, listOfStudents: [Student]) {
        self.lessonNr = lessonNr
        
        for student in listOfStudents {
            attendance[student.studentId] = false
        }
    }
    
    func fromJSONString(JSONString: String) {
        if let dict = convertToDictionary(text: JSONString) {
            if let lessonNr = dict["lessonNr"]{
                print(lessonNr)
            } else {
                print("lessonNr not found")
            }
        } else {
            print("dictionary not created")
        }
    }
    
    func toJSONString() -> String {
        var JSONString = "{\"lessonNr\": \(lessonNr), \"attendance\" : {"
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
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
