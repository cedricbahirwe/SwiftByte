//
//  FirestoreEntity+Protocol.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore

protocol FirestoreEntity: Codable {
    static var collectionName: SBCollectionName { get }
    var id: String? { get }
}

extension FirestoreEntity {

    static var collectionReference: CollectionReference {
        return Firestore.firestore().collection(collectionName)
    }

    var reference: DocumentReference? {
        guard let id  = id else { return nil }

        return type(of: self).collectionReference
            .document(id)
    }

    func set(completion: ((_ result: Result<Void, Error>) -> Void)? = nil) {
        reference?.set(model: self) { (result) in
            guard let completion = completion else { return }
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func update(completion: ((_ result: Result<Void, Error>) -> Void)? = nil) {
        reference?.update(model: self) { (result) in
            guard let completion = completion else { return }
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(completion: ((_ result: Result<Void, Error>) -> Void)? = nil) {
        reference?.delete { (result) in
            guard let completion = completion else { return }
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

