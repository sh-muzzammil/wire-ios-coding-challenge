//
//  ConversationService.swift
//  PlainText
//
//  Created by Muzzammil on 06/05/2024.
//

import Foundation

protocol TransportSessionProtocol {
    func encryptAndSend(
        message: Message,
        completion: ((Result<Void, TransportSession.Failure>) -> Void)?
    )
}

extension TransportSession: TransportSessionProtocol {}

class ConversationService {

    enum Failure: Error {

        case genericError

    }
    
    let transportSession : TransportSessionProtocol

    init(transportSession: TransportSessionProtocol) {
        self.transportSession = transportSession
    }
    
    func appendMessage(
        message: Message,
        completion: ((Result<Bool,Failure>) -> Void)? = nil
    ) {
        transportSession.encryptAndSend(message: message) { result in
            switch result {
            case .success:
                completion?(.success(true))
            case .failure(_):
                completion?(.failure(.genericError))
            }
        }
    }
}
