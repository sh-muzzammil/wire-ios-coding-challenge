//
// Wire
// Copyright (C) 2023 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Identifiable {

    @NSManaged public var name: String
    @NSManaged public var conversations: NSSet
    @NSManaged public var messages: NSSet

    @discardableResult
    class func insertNewObject(
        name: String,
        in context: NSManagedObjectContext
    ) -> User {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.name = name
        user.conversations = NSSet()
        user.messages = NSSet()
        return user
    }

}

// MARK: Generated accessors for messages

extension User {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: - Fetch request

extension User {

    class func fetchrequestForSelfUser() -> NSFetchRequest<User> {
        let request = fetchRequestForAllUsers()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(User.name), "Alice")
        request.fetchLimit = 1
        return request
    }

    class func fetchRequestForAllUsers() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

}
