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

struct ConversationListView: View {

    @EnvironmentObject
    var factory: ModuleFactory

    @ObservedObject
    var viewModel: ConversationListViewModel

    var body: some View {
        List(viewModel.conversations) { conversation in
            cell(for: conversation)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { createNewConversationButton }
        .sheet(isPresented: $viewModel.isPresentingCreateNewConversationModule) {
            CreateConversationView(
                viewModel: factory.createConversationViewModel(withDelegate: viewModel)
            )
        }
    }

    @ViewBuilder
    private func cell(for item: ConversationWrapper) -> some View {
        NavigationLink {
            ConversationContentView(viewModel: factory.conversationContentViewModel(conversation: item.conversation as! Conversation))
        } label: {
            Text(item.name)
        }
    }

    @ViewBuilder
    private var createNewConversationButton: some View {
        Button {
            viewModel.handleEvent(.createNewConversationButtonTapped)
        } label: {
            Image(systemName: viewModel.createNewConversationButtonIconName)
        }
    }
}

// MARK: - Previews

struct ConversationListView_Previews: PreviewProvider {
    static let factory = ModuleFactory.preview

    static var previews: some View {
        return NavigationView {
            ConversationListView(viewModel: factory.conversationListViewModel())
        }
        .environmentObject(factory)
    }
}
