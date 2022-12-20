//
//  Firestore+Extension.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore

extension Firestore {
    func collection(_ name: SBCollectionName) -> CollectionReference {
        collection(name.rawValue)
    }
}

extension DocumentReference {
    func collection(_ name: SBCollectionName) -> CollectionReference {
        collection(name.rawValue)
    }

    func get<Model: Codable>(completion: @escaping (_ result: Result<Model, Error>) -> Void) {
        getDocument(completion: { (snapshot: DocumentSnapshot?, error: Error?) in

            if let error = error {
                completion(.failure(error))
            } else {
                if let data = snapshot?.data() {
                    do {
                        let model = try Firestore.Decoder().decode(Model.self, from: data)
                        completion(.success(model))

                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? SBErrors.noDataFound))
                }
            }
        })
    }

    func set<Model: Codable>(model: Model, completion: @escaping (_ result: Result<Model, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(model)

            setData(data, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(model))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }

    func update<Model: Codable>(model: Model, completion: @escaping (_ result: Result<Model, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(model)

            updateData(data, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(model))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }

    func delete(completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        delete(completion: { (error: Error?) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
}
