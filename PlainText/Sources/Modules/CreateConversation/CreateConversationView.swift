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

struct CreateConversationView: View {

    @ObservedObject
    var viewModel: CreateConversationViewModel
    @Environment(\.dismiss) var dismiss

    @FocusState
    private var focusedField: Field?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleLabel

            Form {
                nameField
                confirmButton
            }
        }
        .onAppear { focusedField = .name }
    }

    @ViewBuilder
    private var titleLabel: some View {
        Text(viewModel.title)
            .font(.title)
            .padding()
    }

    @ViewBuilder
    private var nameField: some View {
        TextField(
            viewModel.namePlaceholder,
            text: $viewModel.name
        )
        .focused($focusedField, equals: .name)
    }

    @ViewBuilder
    private var confirmButton: some View {
        Button {
            viewModel.handleEvent(.confirmButtonTapped)
            dismiss()
        } label: {
            Text(viewModel.confirmButtonText)
        }
        .disabled(viewModel.isConfirmButtonDisabled)
    }

}

private extension CreateConversationView {

    enum Field: Int, Hashable {

        case name

    }

}

// MARK: - Previews

#Preview {
    let factory = ModuleFactory.preview

    return CreateConversationView(viewModel: factory.createConversationViewModel())
        .environmentObject(factory)
}
