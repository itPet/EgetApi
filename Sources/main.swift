//
//  main.swift
//  Perfect JSON API Example
//
//  Created by Jonathan Guthrie on 2016-09-26.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

// Create HTTP server.
let server = HTTPServer()

// Create the container variable for routes to be added to.
var routes = Routes()

func writeToFile(fileName: String, outString: String) {
    let dir = try? FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask, appropriateFor: nil, create: true)

    // If the directory was found, we write a file to it and read it back
    if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {

        // Write to the file named Test
        do {
            try outString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("wrote to \(fileName)")
        } catch {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
    } else {
        print("directory not found!")
    }
}

func readFromFile(fileName: String) -> String {
    let dir = try? FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask, appropriateFor: nil, create: true)
    
    // If the directory was found, we write a file to it and read it back
    if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
        // Then reading it back from the file
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL)
            return inString
        } catch {
            return "Failed reading from URL: \(fileURL), Error: " + error.localizedDescription
        }
    }
    return "directory not found"
}

var studentRegister = StudentRegister.fromJSONString(string: readFromFile(fileName: "StudentRegister"))
var course = Course.fromJSONString(string: readFromFile(fileName: "Course"), listOfStudents: studentRegister.listOfStudents)

// Get - course/MA17
routes.add(method: .get, uri: "/course/MA17", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.toJSONString())
    response.completed()
})

// Get, Put - lessons/{lessonNr}
routes.add(method: .get, uri: "/course/MA17/lessons/{lessonNr}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.getLesson(request: request))
    response.completed()
    writeToFile(fileName: "Course", outString: course.toJSONString())
})

routes.add(method: .put, uri: "/course/MA17/lessons/{lessonNr}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.putLessonFromHTTPRequest(request: request))
    
    writeToFile(fileName: "Course", outString: course.toJSONString())
    
    response.completed()
})

// Get, Post    - students
// Get, Delete  - students/{studentId}
// Get          - students/{studentId}/attendance
routes.add(method: .get, uri: "/students", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.toJSONString())
    response.completed()
})

routes.add(method: .post, uri: "/students", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    studentRegister.addFromHTTPRequest(request: request, course: course)
    response.appendBody(string: studentRegister.toJSONString())
    
    writeToFile(fileName: "Course", outString: course.toJSONString())
    writeToFile(fileName: "StudentRegister", outString: studentRegister.toJSONString())
    
    response.completed()
})

routes.add(method: .get, uri: "/students/{studentId}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.getStudentById(request: request))
    response.completed()
})

routes.add(method: .delete, uri: "/students/{studentId}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.delete(request: request, course: course))
    
    writeToFile(fileName: "Course", outString: course.toJSONString())
    writeToFile(fileName: "StudentRegister", outString: studentRegister.toJSONString())
    
    response.completed()
})

routes.add(method: .get, uri: "/students/{studentId}/attendance", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.studentAttendanceById(request: request, listOfLessons: course.listOfLessons))
    response.completed()
})



// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
