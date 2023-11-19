//
//  FirestoreService.swift
//  mazi
//
//  Created by Ahmed Elsaeed on 18/11/2023.
//

import Foundation
import FirebaseFirestore
import CryptoKit

class FirestoreService {
    let db = Firestore.firestore()
    
    enum CustomError: Error {
        case groupNotFound
        case multipleGroupsFound
    }
    
    func create_user_doc(email: String, uid: String, group_id: String) async throws -> Bool {
        let users_ref = db.collection("users")

        return try await withCheckedThrowingContinuation { continuation in
            users_ref.document(uid).setData([
                "id" : uid,
                "email" : email,
                "groups" : [group_id],
                "joined" : FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func set_username(uid: String, username: String) async throws -> Bool {
        let query_snapshot = try await db.collection("users").whereField("id", isEqualTo: uid).getDocuments()
        
        guard query_snapshot.documents.count == 1 else {
            throw CustomError.multipleGroupsFound
        }

        guard let document = query_snapshot.documents.first else {
            throw CustomError.groupNotFound
        }
        
        return try await withCheckedThrowingContinuation{
            continuation in
            document.reference.updateData(["username" : username]) {
                err in
                if let err = err {
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
}
