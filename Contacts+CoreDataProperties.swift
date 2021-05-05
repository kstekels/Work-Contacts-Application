//
//  Contacts+CoreDataProperties.swift
//  Work Contact Application
//
//  Created by karlis.stekels on 05/05/2021.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var position: String?
    @NSManaged public var projects: [String]?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?

}

extension Contacts : Identifiable {

}
