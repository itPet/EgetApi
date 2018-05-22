//
//  Course.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation
import PerfectHTTP

class Course {
    var name : String
    var listOfLessons = [Lesson]()
    
    init(listOfStudents: [Student]) {
        name = "MA17"
        
        for i in 1...5 {
            listOfLessons.append(Lesson(lessonNr: i, listOfStudents: listOfStudents))
        }
    }
    
//    func writeToFile() {
//        let fileName = "Test"
//        let dir = try? FileManager.default.url(for: .documentDirectory,
//                                               in: .userDomainMask, appropriateFor: nil, create: true)
//        
//        // If the directory was found, we write a file to it and read it back
//        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
//            
//            // Write to the file named Test
//            let outString = "Write this text to the file"
//            do {
//                try outString.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
//            }
//            
//            // Then reading it back from the file
//            var inString = ""
//            do {
//                inString = try String(contentsOf: fileURL)
//            } catch {
//                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
//            }
//            print("Read from the file: \(inString)")
//        }
//    }
    
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
        let JSONString = "{\"courseName\": \"\(name)\", \"Lessons\": [\(lessons)]}"
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
