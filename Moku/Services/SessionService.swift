//
//  SessionService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 18/10/21.
//

import Combine

final class SessionService: ObservableObject {
    // Shared Instance
    static let shared = SessionService()

    @Published var user: User?

    private init() {}
}

extension SessionService {
    enum User {
        case customer(_ customer: Customer)
        case bengkel(_ bengkel: Bengkel)
    }
}
