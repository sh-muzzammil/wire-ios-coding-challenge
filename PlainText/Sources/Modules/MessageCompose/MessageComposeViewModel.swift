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

final class MessageComposeViewModel: ObservableObject {

    // MARK: - State

    @Published
    var content: String
    let placeholder = "Type a message"

    var isButtonDisabled: Bool { content.isEmpty }
    let sendButtonIconName = "arrow.up.circle.fill"

    // MARK: - Properties

    private let onMessageComposed: ((String) -> Void)?

    // MARK: - Life cycle

    init(onMessageComposed: ((String) -> Void)? = nil) {
        self.content = ""
        self.onMessageComposed = onMessageComposed
    }

    // MARK: - Methods

    enum Event {

        case sendButtonTapped

    }

    func handleEvent(_ event: Event) {
        switch event {
        case .sendButtonTapped:
            onMessageComposed?(content)
            content = ""
        }
    }

}
