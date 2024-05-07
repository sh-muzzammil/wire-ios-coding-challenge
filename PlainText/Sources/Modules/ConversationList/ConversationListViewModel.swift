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

protocol ConversationProtocol {
    var name: String { get }
}

extension Conversation: ConversationProtocol {}

struct ConversationWrapper: Identifiable {
    var id: String {
        name
    }

    let conversation: ConversationProtocol
    init(conversation: ConversationProtocol) {
        self.conversation = conversation
    }

    var name: String { conversation.name }
}

protocol ConversationStore {
    var conversationsPublisher: AnyPublisher<[ConversationWrapper], Never> { get }
}

class CoreDataConversationStore: ConversationStore {
    private let fr: FetchedResults<Conversation>

    init(fr: FetchedResults<Conversation>) {
        self.fr = fr
    }

    var conversationsPublisher: AnyPublisher<[ConversationWrapper], Never> {
        fr.$results.map{ $0.map{ ConversationWrapper(conversation: $0) } }.eraseToAnyPublisher()
    }
}

final class ConversationListViewModel: ObservableObject {

    // MARK: - State

    let title = "Conversations"
    let createNewConversationButtonIconName = "square.and.pencil"

    @Published
    var conversations = [ConversationWrapper]()

    @Published
    var isPresentingCreateNewConversationModule = false

    // MARK: - Properties

    private let conversationStore: ConversationStore
    private var subscription: AnyCancellable?

    // MARK: - Life cycle

    init(conversationStore: ConversationStore) {
        self.conversationStore = conversationStore
        self.subscription = conversationStore
            .conversationsPublisher
            .assign(to: \.conversations, on: self)
    }

    // MARK: - Methods

    enum Event {

        case createNewConversationButtonTapped
        case newConversationCreated

    }

    func handleEvent(_ event: Event) {
        switch event {
        case .createNewConversationButtonTapped:
            presentConversationCreationModule()

        case .newConversationCreated:
            dismissConversationCreationModule()
        }
    }

    private func presentConversationCreationModule() {
        isPresentingCreateNewConversationModule = true
    }

    private func dismissConversationCreationModule() {
        isPresentingCreateNewConversationModule = false
    }

}

extension ConversationListViewModel: CreateConversationViewModelDelegate {
    func didCreateConversation() {
        handleEvent(.newConversationCreated)
        isPresentingCreateNewConversationModule.toggle()
    }
}
