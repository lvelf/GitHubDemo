//
//  ChooseData+CoreDataProperties.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/3.
//
//

import Foundation
import CoreData


extension ChooseData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChooseData> {
        return NSFetchRequest<ChooseData>(entityName: "ChooseData")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageName: String?
    @NSManaged public var choosed: Bool

}

extension ChooseData : Identifiable {

}
