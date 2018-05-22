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

// Create HTTP server.
let server = HTTPServer()

// Create the container variable for routes to be added to.
var routes = Routes()

var studentRegister = StudentRegister()
var course = Course(listOfStudents: studentRegister.listOfStudents)

// Get - course/MA17
routes.add(method: .get, uri: "/course/MA17", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.toJSONString())
    response.completed()
})

// Get, Put - lesson/{lessonNr}
routes.add(method: .get, uri: "/course/MA17/lesson/{lessonNr}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.getLesson(request: request))
    response.completed()
})

routes.add(method: .put, uri: "/course/MA17/lesson/{lessonNr}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: course.putLessonFromHTTPRequest(request: request))
    response.completed()
})

// Get, Post    - students
// Get, Delete  - students/{studentId}
// Get          - students/attendance/{studentId}
routes.add(method: .get, uri: "/students", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.toJSONString())
    response.completed()
})

routes.add(method: .post, uri: "/students", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    studentRegister.addFromHTTPRequest(request: request)
    response.appendBody(string: studentRegister.toJSONString())
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
    response.appendBody(string: studentRegister.delete(request: request))
    response.completed()
})

routes.add(method: .get, uri: "/students/attendance/{studentId}", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: studentRegister.studentAttendanceById(request: request, listOfLessons: course.listOfLessons))
    response.completed()
})





// This is an example "Hello, world!" HTML route
routes.add(method: .get, uri: "/", handler: {
	request, response in
	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")
	// Adding some HTML to the response body object
	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	// Signalling that the request is completed
	response.completed()
	}
)

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
