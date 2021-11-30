//
//  StorageService.swift
//  Moku
//
//  Created by Devin Winardi on 01/11/21.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class StorageService: ObservableObject {
    var storageRef = Storage.storage().reference()

    static let shared = StorageService()

    // MARK: - GET DOWNLOAD URL
    private func getDownloadURL(from path: String, completion: ((URL?, Error?) -> Void)? = nil) {
        storageRef.child(path).downloadURL { url, error in
            if let error = error {
                completion?(nil, error)
            } else if let url = url {
                completion?(url, nil)
            }
        }
    }

    func delete(url: String, completionHandler: (() -> Void)? = nil) {
        let mediaRef = Storage.storage().reference(forURL: url)
        mediaRef.delete { _ in
            completionHandler?()
        }
    }

    func upload(image: UIImage, path: String, completion: ((URL?, Error?) -> Void)? = nil) {
        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 0.2)

        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        // Upload the image
        if let data = data, let id = Auth.auth().currentUser?.uid {
            DispatchQueue.global(qos: .background).async {
                self.storageRef.child("images/\(id)/\(path).jpg").putData(data, metadata: metadata) { metadata, error in
                    if let error = error {
                        completion?(nil, error)
                        return
                    }

                    // then we check if the metadata and path exists
                    // if the error was nil, we expect the metadata and path to exist
                    // therefore if not, we return an error
                    guard let metadata = metadata, let path = metadata.path else {
                        completion?(nil, NSError(
                            domain: "core",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Unexpected error. Path is nil."])
                        )
                        return
                    }

                    // now we get the download url using the path
                    // and the basic reference object (without child paths)
                    self.getDownloadURL(from: path, completion: completion)
                }
            }
        }
    }

    func listAllFiles() {
        // List all items in the images folder
        storageRef.child("images").listAll { result, error in
            if let error = error {
                print("Error while listing all files: ", error)
            }

            for item in result.items {
                print("Item in images folder: ", item)
            }
        }
    }

    // You can use the listItem() function above to get the StorageReference of the item you want to delete
    func deleteItem(item: StorageReference) {
        item.delete { error in
            if let error = error {
                print("Error deleting item", error)
            }
        }
    }
}
