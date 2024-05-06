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

final class CreateConversationViewModel: ObservableObject {

    // MARK: - State

    let title = "Create conversation"
    @Published var name = ""
    let namePlaceholder = "Name"
    let confirmButtonText = "Create"
    var isConfirmButtonDisabled: Bool {
        return name.isEmpty
    }

    // MARK: - Dependencies

    let context: NSManagedObjectContext

    // MARK: - Properties

    weak var delegate: CreateConversationViewModelDelegate?

    // MARK: - Life cycle

    init(
        context: NSManagedObjectContext,
        delegate: CreateConversationViewModelDelegate?
    ) {
        self.context = context
        self.delegate = delegate
    }

    // MARK: - Methods

    enum Event {

        case confirmButtonTapped

    }

    func handleEvent(_ event: Event) {
        switch event {
        case .confirmButtonTapped:
            createConversation()
        }
    }

    private func createConversation() {
        let fetchRequest = User.fetchRequestForAllUsers()
        let allUsers = try! context.fetch(fetchRequest)
        // TODO: Can we think of maybe adding a way of setting participants in the conversation
        _ = Conversation.insertNewObject(name: name, participants: Set(allUsers), in: context)
        try! context.save()
        delegate?.didCreateConversation()
    }

}

protocol CreateConversationViewModelDelegate: AnyObject {
    func didCreateConversation()
}
