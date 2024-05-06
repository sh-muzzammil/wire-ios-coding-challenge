//
//  ConversationService.swift
//  PlainText
//
//  Created by Muzzammil on 06/05/2024.
//

import Foundation

class ConversationService {

    enum Failure: Error {

        case networkError

    }
    
    let transportSession : TransportSession

    init(transportSession: TransportSession) {
        self.transportSession = transportSession
    }
    
    func appendMessage(
        message: Message,
        completion: ((Result<Bool,Failure>) -> Void)? = nil
    ) async throws -> Result<Bool,Failure> {
        
            let result = try await transportSession.encryptAndSend(message: message)
                switch result {
                case .success:
                    do {
                          return .success(true)
                    }

                case .failure(let error):
                    print("failed to send message: \(error)")
                }
        return .success(true)
    }
}
