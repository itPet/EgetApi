//
//  StudentRegister.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation
import PerfectHTTP

class StudentRegister {
    
    var listOfStudents = [Student]()
    
    init() {
        listOfStudents = [Student(firstName: "Peter", lastName: "Karlsson", studentId: "001"),
            Student(firstName: "Nils", lastName: "Svensson", studentId: "002"),
            Student(firstName: "Arne", lastName: "Wing", studentId: "003")]
    }
    
    func getStudentById(request: HTTPRequest) -> String {
        if let studentId = request.urlVariables["studentId"] {
            for i in 0...listOfStudents.count-1 {
                if listOfStudents[i].studentId == studentId {
                    return listOfStudents[i].toJSONString()
                }
            }
            return "No student with studentId: \(studentId)"
        } else {
            return "Error!"
        }
    }
    
    func addFromHTTPRequest (request: HTTPRequest) {
        let dictionary = convertToDictionary(text: request.postBodyString!)
        
        let newStudent = Student(firstName: dictionary?["firstName"] as? String ?? "",
                                 lastName: dictionary?["lastName"] as? String ?? "",
                                 studentId: UUID().uuidString)
        
        listOfStudents.append(newStudent)
    }
    
    func delete(request: HTTPRequest) -> String {
        if let studentId = request.urlVariables["studentId"] {
            for i in 0...listOfStudents.count-1 {
                if listOfStudents[i].studentId == studentId {
                    listOfStudents.remove(at: i)
                    return toJSONString()
                }
            }
            return "No student with studentId: \(studentId)"
        } else {
            return "Error"
        }
    }
    
    func studentAttendanceById(request: HTTPRequest, listOfLessons: [Lesson]) -> String {
        if let studentId = request.urlVariables["studentId"] {
            for i in 0...listOfStudents.count-1 {
                if listOfStudents[i].studentId == studentId {
                    let firstName = listOfStudents[i].firstName
                    let lastName = listOfStudents[i].lastName
                    var JSONString = "{\"firstName\":\"\(firstName)\", \"lastName\":\"\(lastName)\", \"studentId\":\"\(studentId)\", \"attendance\": {"
                    for i in 0...listOfLessons.count - 1 {
                        JSONString.append("\"Lesson\(listOfLessons[i].lessonNr)\": \(listOfLessons[i].attendance[studentId]!)")
                        if i != listOfLessons.count - 1 {
                            JSONString.append(",")
                        } else {
                            JSONString.append("}}")
                        }
                    }
                    return JSONString
                }
            }
                return "No student with studentId: \(studentId)"
        } else {
            return "Error!"
        }
    }
    
    func toJSONString() -> String {
        var JSONString = ""
        for i in 0...listOfStudents.count-1 {
            if i == 0 {
                JSONString.append("[")
            }
            JSONString.append(listOfStudents[i].toJSONString())
            if i != listOfStudents.count-1 {
                JSONString.append(",")
            } else {
                JSONString.append("]")
            }
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
