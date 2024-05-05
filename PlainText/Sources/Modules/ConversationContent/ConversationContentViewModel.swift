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

    private let fetchedResults: FetchedResults<Message>
    private var subscription: AnyCancellable?

    private let transportSession = TransportSession()

    init(
        selfUser: User,
        conversation: Conversation,
        context: NSManagedObjectContext
    ) {
        self.title = conversation.name
        self.selfUser = selfUser
        self.conversation = conversation

        self.fetchedResults = FetchedResults(
            request: Message.sortedFetchRequestForMessages(in: conversation),
            context: context
        )

        self.subscription = fetchedResults.$results.assign(to: \.messages, on: self)
    }

    enum Event {

        case didComposeMessage(String)

    }

    func handleEvent(_ event: Event) {
        switch event {
        case .didComposeMessage(let content):
            appendMessage(content: content)
        }
    }

    private func appendMessage(content: String) {
        guard
            !content.isEmpty,
            let context = conversation.managedObjectContext
        else {
            return
        }

        let message = Message.insertNewObject(
            content: content,
            sender: selfUser,
            conversation: conversation,
            in: context
        )

        conversation.lastModifiedDate = .now
        try? context.save()

        Task {
            let result = try await transportSession.encryptAndSend(message: message)
            await MainActor.run {
                switch result {
                case .success:
                    do {
                        message.markAsSent()
                        try context.save()
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
