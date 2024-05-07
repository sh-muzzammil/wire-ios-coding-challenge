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
import Combine

final class ConversationContentViewModel: ObservableObject {

    let title: String

    @Published
    var messages = [Message]()

    private let selfUser: User
    private let conversation: Conversation

    private var fetchedResults: FetchedResults<Message>
    private var subscription: AnyCancellable?

    private let context: NSManagedObjectContext
    private let bgContext: NSManagedObjectContext
    var conversationService: ConversationService

    init(
        selfUser: User,
        conversation: Conversation,
        context: NSManagedObjectContext,
        bgContext: NSManagedObjectContext,
        conversationService : ConversationService
    ) {
        self.title = conversation.name
        self.selfUser = selfUser
        self.conversation = conversation
        self.context = context
        self.bgContext = bgContext
        self.conversationService = conversationService
        self.fetchedResults = FetchedResults(
            request: Message.sortedFetchRequestForMessages(in: conversation),
            context: context
        )

        self.subscription = fetchedResults.$results.assign(to: \.messages, on: self)
    }

    enum Event {

        case didComposeMessage(String)
        case reloadMessagesList


    }

    func handleEvent(_ event: Event) {
        switch event {
        case .didComposeMessage(let content):
            appendMessage(content: content)
            
        case .reloadMessagesList:
            sortList()
        }
    }

    private func sortList(){
        
        self.fetchedResults = FetchedResults(
            request: Message.sortedFetchRequestForMessages(in: conversation),
            context: context
        )

        self.subscription = fetchedResults.$results.assign(to: \.messages, on: self)
    }
    
    func appendMessage(content: String) {
        guard
            !content.isEmpty,
            let context = conversation.managedObjectContext
        else {
            return
        }

        bgContext.perform {
            guard
                let bgConversation = self.bgContext.object(with: self.conversation.objectID) as? Conversation,
                let bgSelfUser = self.bgContext.object(with: self.selfUser.objectID) as? User
            else {
                return
            }
            let bgMessage = Message.insertNewObject(
                content: content,
                sender: bgSelfUser,
                conversation: bgConversation,
                in: self.bgContext
            )
            bgConversation.lastModifiedDate = .now
            try? self.bgContext.save()

            self.conversationService.appendMessage(message: bgMessage) { [weak self] result in
                switch result {
                case .success:
                    do {
                        bgMessage.markAsSent()
                        try self?.bgContext.save()
                        self?.context.perform {
                            try? self?.context.save()
                            self?.sortList()
                        }
                    } catch {
                        print("failed to append message: \(error)")
                    }

                case .failure(let error):
                    print("failed to send message: \(error)")
                }
            }
        }
    }

}
