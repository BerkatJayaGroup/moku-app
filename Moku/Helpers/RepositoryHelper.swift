//
//  RepositoryHelper.swift
//  Moku
//
//  Created by Christianto Budisaputra on 14/10/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct RepositoryHelper {
    static func handleQueryError(_ error: Error) {
        // Resolve the error, ex: Show popup etc.
        print("Unresolved Error: Failed to query data;", error.localizedDescription)
    }

    static func handleParsingError(_ error: Error) {
        // Resolve the error, ex: Show popup etc.
        print("Unresolved Error: Failed to parse data;", error.localizedDescription)
    }

    static func extractData<T: Decodable>(from documents: [QueryDocumentSnapshot], type: T.Type) -> [T] {
        var results = [T]()

        for document in documents {
            guard let data = try? document.data(as: T.self) else { continue }
            results.append(data)
        }

        return results
    }

    static func extractDocuments(_ snapshot: QuerySnapshot?, _ error: Error?) -> [QueryDocumentSnapshot]? {
        if let error = error {
            handleQueryError(error)
        } else if let snapshot = snapshot {
            return snapshot.documents
        }

        return nil
    }
}
