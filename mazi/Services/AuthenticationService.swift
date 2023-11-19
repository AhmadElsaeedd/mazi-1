//
//  AuthenticationService.swift
//  mazi
//
//  Created by Ahmed Elsaeed on 18/11/2023.
//


import Foundation
import FirebaseAuth

class AuthenticationService{
    let auth = Auth.auth()
    
    enum CustomError: Error {
            case emailInUse
            case invalidEmail
            case wrongPassword
            case userNotFound
            case unknownError
            case genericError
            case internalError
        }
    
    func loginOrCreateUser(email: String, password: String) async throws -> (email: String, uid: String) {
        print("Email and password are: ", email, " ", password)
        return try await withCheckedThrowingContinuation { continuation in
            auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                if let error = error as NSError? {
                    let generalErrorMessage = error.localizedDescription
                    if let userInfo = error.userInfo as? [String: Any],
                       let firebaseError = userInfo["FIRAuthErrorUserInfoNameKey"] as? String {
                    print("FIREBASE ERROR: ", firebaseError)
                        switch firebaseError {
                        case "ERROR_USER_NOT_FOUND":
                            // Handle user not found by attempting to create a new user
                            self?.createUser(email: email, password: password, continuation: continuation)
                        case "ERROR_INVALID_EMAIL":
                            print("Invalid email")
                            continuation.resume(throwing: CustomError.invalidEmail)
                        case "ERROR_WRONG_PASSWORD":
                            print("Invalid password")
                            continuation.resume(throwing: CustomError.wrongPassword)
                        case "ERROR_INTERNAL_ERROR":
                            if let underlyingError = userInfo[NSUnderlyingErrorKey] as? NSError {
                                let detailedErrorMessage = underlyingError.localizedDescription
                                print("Detailed error: \(detailedErrorMessage)")
                            }
                            continuation.resume(throwing: CustomError.internalError)
                        default:
                            print("Unhandled Firebase error: \(firebaseError)")
                            continuation.resume(throwing: CustomError.genericError)
                        }
                    } else {
                        print("Generic error: \(generalErrorMessage)")
                        continuation.resume(throwing: CustomError.genericError)
                    }
                } else if let uid = result?.user.uid {
                    continuation.resume(returning: (email: email, uid: uid))
                } else {
                    continuation.resume(throwing: CustomError.unknownError)
                }
            }
        }
    }

    private func createUser(email: String, password: String, continuation: CheckedContinuation<(email: String, uid: String), Error>) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                print("Firebase error: \(error.localizedDescription)")
                continuation.resume(throwing: CustomError.genericError)
            } else if let uid = result?.user.uid {
                continuation.resume(returning: (email: email, uid: uid))
            } else {
                continuation.resume(throwing: CustomError.unknownError)
            }
        }
    }

    func logout() async throws -> Bool {
        try auth.signOut()
        return true
    }

    
    func get_user_id() -> String? {
        return auth.currentUser?.uid
    }

}
