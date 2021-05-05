//
//  Employees.swift
//  Work Contact Application
//
//  Created by karlis.stekels on 04/05/2021.
//

import Foundation

struct Employees: Decodable {
    var employees: [Employee]
}

struct Employee: Decodable {
    var fname: String
    var lname: String
    var contact_details: [String: String]?
    var position: String
    var projects: [String]?
}
