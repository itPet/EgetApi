//
//  Course.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation
import PerfectHTTP

class Course: Codable {
    var courseName : String
    var listOfLessons = [Lesson]()
    
    init(listOfStudents: [Student]) {
        courseName = "MA17"
        
        for i in 1...5 {
            listOfLessons.append(Lesson(lessonNr: i, listOfStudents: listOfStudents))
        }
    }
    
    static func fromJSONString(string: String, listOfStudents: [Student]) -> Course {
        let jsonObject = string.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let course = try decoder.decode(Course.self, from: jsonObject)
            return course
        } catch {
            print("error trying to convert data to JSON")
            print(error)
            return Course(listOfStudents: listOfStudents)
        }
    }
    
    func putLessonFromHTTPRequest(request: HTTPRequest) -> String {
        let wrongInput = "Wrong JSON! Should be studentId: String, attendance: Bool"
        if let lessonNr = Int(request.urlVariables["lessonNr"]!) {
            if lessonNr > 0 && lessonNr < listOfLessons.count {
                if let dictionary = convertToDictionary(text: request.postBodyString!) {
                    if let studentId = dictionary["studentId"] as? String {
                        if let attendance = dictionary["attendance"] as? Bool{
                            if listOfLessons[lessonNr-1].attendance[studentId] != nil {
                                listOfLessons[lessonNr-1].attendance[studentId] = attendance
                                return listOfLessons[lessonNr-1].toJSONString()
                            } else {
                                return "There is no studentId \(studentId)"
                            }
                        } else {
                            return wrongInput
                        }
                    } else {
                        return wrongInput
                    }
                } else {
                    return wrongInput
                }
            } else {
                return "there is no lessonNr \(lessonNr)"
            }
        } else {
            return "Error! urlVariable has to be Int"
        }
   }
    
    func getLesson(request: HTTPRequest) -> String {
        //let lessonNr2 = request.urlVariables["lessonNr"] as? Int
        if let lessonNr = Int(request.urlVariables["lessonNr"]!) {
            if lessonNr > 0 && lessonNr < listOfLessons.count {
                return listOfLessons[lessonNr-1].toJSONString()
            } else {
                return "there is no lessonNr \(lessonNr)"
            }
        } else {
            return "Error! urlVariable has to be Int"
        }
    }
    
    func toJSONString() -> String {
        var lessons = ""
        for i in 0...listOfLessons.count - 1 {
            lessons.append(listOfLessons[i].toJSONString())
            if i != listOfLessons.count - 1{
                lessons.append(",")
            }
        }
        let JSONString = "{\"courseName\": \"\(courseName)\", \"listOfLessons\": [\(lessons)]}"
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
