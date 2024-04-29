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

struct MessageComposeView: View {

    @ObservedObject
    var viewModel: MessageComposeViewModel

    var body: some View {
        HStack(spacing: 8) {
            inputField
            sendButton
        }
        .padding()
    }

    @ViewBuilder
    private var inputField: some View {
        TextField(
            viewModel.placeholder,
            text: $viewModel.content
        )
    }

    @ViewBuilder
    private var sendButton: some View {
        Button {
            viewModel.handleEvent(.sendButtonTapped)
        } label: {
            Image(systemName: viewModel.sendButtonIconName)
                .resizable()
                .frame(width: 40, height: 40)
        }
        .disabled(viewModel.isButtonDisabled)
    }

}

// MARK: - Previews

#Preview {
    MessageComposeView(viewModel: MessageComposeViewModel())
        .previewLayout(.sizeThatFits)
}
