//
//  MyShows+CoreDataProperties.swift
//  MyTvShows
//
//  Created by Jair on 21/11/20.
//
//

import Foundation
import CoreData


extension MyShows {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyShows> {
        return NSFetchRequest<MyShows>(entityName: "MyShows")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var img: String?

}

extension MyShows : Identifiable {

}
