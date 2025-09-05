//
//  SBFireBaseImageUploader.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Firebase
import FirebaseStorage

final class SNFirebaseImageUploader {
    static let shared = SNFirebaseImageUploader()
    private init() { }
    var uploadedfilePath: String?

    func upload(data: Data,
                format: SBFileExtension,
                path: SBFBFilePath,
                completionHandler:  @escaping (Result<URL, SBErrors>) -> Void) {

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let newFileID = UUID()

        let meta = StorageMetadata()
        meta.contentType = "image/png"
        let fullPath = "\(path.rawValue)/\(newFileID).\(format.rawValue)"
        self.uploadedfilePath = fullPath
        let riversRef = storageRef.child(fullPath)
        let uploadTask = riversRef.putData(data, metadata: meta) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                completionHandler(.failure(.unknownError(error)))
                printf("Error occured: \(String(describing: error))")
                return
            }

            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print("Meta data size", size)
        }

        _ = uploadTask.observe(.progress) { snapshot in
            print("Progress at upload: \(snapshot)")
        }

        _  = uploadTask.observe(.success) { snapshot in
            snapshot.reference.downloadURL(completion: { url, error in
                if let url = url {
                    completionHandler(.success(url))
                } else {
                    completionHandler(.failure(.unknownError(error)))
                }
            })
        }

        _ = uploadTask.observe(.failure) { snapshot in
            printf("Failure at snapshot \(snapshot)")
        }
    }


    func deleteLastUploadedFile(completion: @escaping(Bool) -> Void) {
        guard let uploadedfilePath = uploadedfilePath else {
            return
        }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let rencentRef = storageRef.child(uploadedfilePath)

        // Delete the file
        rencentRef.delete { error in
          if let error = error {
              printf("Failed to delete", error)
              completion(false)
            // Uh-oh, an error occurred!
          } else {
              prints("File deleted")
              completion(true)
          }
        }
    }
}
