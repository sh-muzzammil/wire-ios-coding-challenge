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

import SwiftUI

struct ConversationContentView: View {

    @EnvironmentObject
    var factory: ModuleFactory

    @ObservedObject
    var viewModel: ConversationContentViewModel

    @State
    var text: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            messageList
            Spacer()
            composeView
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var messageList: some View {
        List(viewModel.messages) { message in
            cell(for: message)
        }
    }

    @ViewBuilder
    private func cell(for item: Message) -> some View {
        VStack(alignment: .leading) {
            Text(item.sender.name).bold()
            Text(item.content).foregroundColor(item.isSent ? .primary : .red)
        }
    }

    @ViewBuilder
    private var composeView: some View {
        MessageComposeView(viewModel: factory.messageComposeViewModel {
            viewModel.handleEvent(.didComposeMessage($0))
        })
    }

}
