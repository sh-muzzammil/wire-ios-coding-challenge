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

final class TransportSession {

    enum Failure: Error {

        case networkError

    }


    // ⚠️ IMPORTANT
    //
    // NOTE: Do not modify this any code in this file. In order to place some
    // constraints in this challenge, please consider this class a black box
    // which can not be changed.

    func encryptAndSend(
        message: Message,
        completion: ((Result<Void, Failure>) -> Void)? = nil
    ) {
        let plainText = message.content
        let cipherText = encrypt(plainText)
        send(cipherText)
        completion?(.success(()))
    }

    private func encrypt(_ plainText: String) -> String {
        // Super slow encryption...
        Thread.sleep(forTimeInterval: 3)
        return plainText
    }

    private func send(_ message: String) {
        print("Message sent!")
    }

}
