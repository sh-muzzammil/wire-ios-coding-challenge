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

@objc
public class Conversation: NSManagedObject, Identifiable {

    @NSManaged public var name: String
    @NSManaged public var lastModifiedDate: Date
    @NSManaged public var participants: NSSet
    @NSManaged public var messages: NSSet

    @discardableResult
    class func insertNewObject(
        name: String,
        participants: Set<User> = [],
        in context: NSManagedObjectContext
    ) -> Conversation {
        let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as! Conversation
        conversation.name = name
        conversation.lastModifiedDate = .now
        conversation.participants = NSSet(array: Array(participants))
        conversation.messages = NSSet()
        return conversation
    }

}

// MARK: Generated accessors for participants

extension Conversation {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: User)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: User)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}

// MARK: Generated accessors for messages

extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: - Fetch requests

extension Conversation {

    class func sortedfetchRequestForAllConversations() -> NSFetchRequest<Conversation> {
        let request = fetchRequestForAllConversations()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Conversation.lastModifiedDate, ascending: false)]
        return request
    }

    class func fetchRequestForAllConversations() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

}

