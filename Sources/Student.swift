//
//  Student.swift
//  Perfect-JSON-API
//
//  Created by Peter Karlsson on 2018-05-17.
//

import Foundation


class Student: Codable {
    var firstName : String
    var lastName : String
    var studentId : String
    
    init(firstName: String, lastName: String, studentId: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.studentId = studentId
    }
    
    func toJSONString() -> String {
        let JSONString = "{\"firstName\":\"\(firstName)\",\"lastName\":\"\(lastName)\",\"studentId\":\"\(studentId)\"}"
        return JSONString
    }
    
}
