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

final class ModuleFactory: ObservableObject {

    // MARK: - Properties

    let selfUser: User
    private let persistence: PersistenceController

    // MARK: - Life cycle

    init(persistence: PersistenceController = PersistenceController()) {
        self.persistence = persistence

        let fetchRequest = User.fetchrequestForSelfUser()
        selfUser = try! persistence.viewContext.fetch(fetchRequest).first!
    }

    // MARK: - View model creation

    func rootViewModel() -> RootViewModel {
        return RootViewModel()
    }

    func conversationListViewModel() -> ConversationListViewModel {
        return ConversationListViewModel(context: persistence.viewContext)
    }

    func createConversationViewModel(onConversationCreated: (() -> Void)? = nil) -> CreateConversationViewModel {
        return CreateConversationViewModel(
            context: persistence.viewContext,
            onConversationCreated: onConversationCreated
        )
    }

    func conversationContentViewModel(conversation: Conversation) -> ConversationContentViewModel {
        return ConversationContentViewModel(
            selfUser: selfUser,
            conversation: conversation,
            context: persistence.viewContext
        )
    }

    func messageComposeViewModel(onMessageComposed: ((String) -> Void)? = nil) -> MessageComposeViewModel {
        return MessageComposeViewModel(onMessageComposed: onMessageComposed)
    }

}

extension ModuleFactory {

    static let preview = ModuleFactory(persistence: .preview)

}
