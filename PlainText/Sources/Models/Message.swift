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
public class Message: NSManagedObject, Identifiable {

    @NSManaged
    public var content: String

    @NSManaged
    public var timestamp: Date

    @NSManaged
    public var sender: User

    @NSManaged
    public private(set) var isSent: Bool
    
    @NSManaged
    public var conversation: Conversation

    @discardableResult
    class func insertNewObject(
        content: String,
        timestamp: Date = .now,
        sender: User,
        isSent: Bool = false,
        conversation: Conversation,
        in context: NSManagedObjectContext
    ) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.content = content
        message.timestamp = timestamp
        message.sender = sender
        message.isSent = isSent
        message.conversation = conversation
        return message
    }

}

// MARK: - Fetch requests

extension Message {

    class func sortedFetchRequestForMessages(in conversation: Conversation) -> NSFetchRequest<Message> {
        let request = fetchRequestForMessages(in: conversation)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Message.timestamp, ascending: true)]
        return request
    }

    class func fetchRequestForMessages(in conversation: Conversation) -> NSFetchRequest<Message> {
        let request = fetchRequestForAllMessages()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Message.conversation), conversation)
        return request
    }

    class func fetchRequestForAllMessages() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

}

// MARK: - Logic

extension Message {

    func markAsSent() {
        isSent = true
    }

}
