//
//  Lauched+CoreDataProperties.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/3.
//
//

import Foundation
import CoreData


extension Lauched {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lauched> {
        return NSFetchRequest<Lauched>(entityName: "Lauched")
    }

    @NSManaged public var lauched: Bool

}

extension Lauched : Identifiable {

}
