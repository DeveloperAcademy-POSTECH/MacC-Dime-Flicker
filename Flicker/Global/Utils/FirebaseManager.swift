//
//  FirebaseManager.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
    
    func signInUser(email: String, password: String) async -> String? {
        do {
            let data = try await auth.signIn(withEmail: email, password: password)
            print("Success LogIn")
            return data.user.uid
        } catch {
            print("Failed to LogIn")
            return nil
        }
    }
    
    func createNewAccount(email: String, password: String) async {
        do {
            try await auth.createUser(withEmail: email, password: password)
            print("Successfully created user")
        } catch {
            print("Failed to create user")
        }
    }
    
    func deleteAccount() async {
        do {
            try await auth.currentUser?.delete()
        } catch {
            print("Failed to disconnect friend")
        }
    }
    
    func storeUserInformation(email: String, name: String, profileImage: UIImage) async {
        guard let uid = auth.currentUser?.uid else { return }
        do {
            let ref = storage.reference(withPath: uid)
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
            
            let result = try await ref.putDataAsync(imageData, metadata: nil)
            print(result)
            
            let profileImageUrl = try await ref.downloadURL().absoluteString
            let appDelegate = await UIApplication.shared.delegate as! AppDelegate
            let userToken = await appDelegate.userToken
            let userData = ["email": email, "uid": uid, "name": name, "profileImageUrl": profileImageUrl, "token": userToken]
            
            try await firestore.collection("users").document(uid).setData(userData)
        } catch {
            print("Store User error")
        }
    }
    
    func getUser() async -> User? {
        guard let uid = auth.currentUser?.uid else { return nil }
        do {
            let user = try await firestore.collection("users").document(uid).getDocument(as: User.self)
            print("Success get user")
            return user
        } catch {
            print("Get User error")
            return nil
        }
    }
    
    func getUserWithId(id: String) async -> User? {
        do {
            let user = try await firestore.collection("users").document(id).getDocument(as: User.self)
            print("Success get user")
            return user
        } catch {
            print("Get User error")
            return nil
        }
    }
    
    func updateUserToken(uid: String) async {
        do {
            let appDelegate = await UIApplication.shared.delegate as! AppDelegate
            let userToken = await appDelegate.userToken
            try await firestore.collection("users").document(uid).updateData(["token" : userToken])
            print("Success Update")
        } catch {
            print("Update User error")
        }
    }
    
    func getUsers() async -> [User]? {
        guard let uid = auth.currentUser?.uid else { return nil }
        do {
            var users = [User]()
            
            let documentsSnapshot = try await firestore.collection("users").getDocuments()
            
            documentsSnapshot.documents.forEach({ snapshot in
                guard let user = try? snapshot.data(as: User.self) else { return }
                if user.uid != uid {
                    users.append(user)
                }
            })
            print("Success get users")
            return users
        } catch {
            print("Get Users error")
            return nil
        }
    }
    
    // TODO: - 여기서 uid 어떻게 사용해야하나??? 이거만 처리하면 얼추 처리 된듯? + Task 그 이미지 처리하는 거 잘 붙여 넣고, Task 처리 잘하고... 그리고 테스트를 위해서 붙였던 등록 맨 끝 뒤에 바로 에디트뷰로 옮긴거 잘 해놓자.
    func getArtists() async -> Artist? {
//        guard let uid = auth.currentUser?.uid else { return nil } ⭐️
        do {
            var downloadedArtist = Artist(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImageUrls: [], userInfo: [:])
            
            let documentsSnapshot = try await firestore.collection("artists").getDocuments()
            
            await documentsSnapshot.documents.asyncForEach({ snapshot in
                guard let artist = try? snapshot.data(as: Artist.self) else { return }
                downloadedArtist = artist
            })
            
            return downloadedArtist
        } catch {
            print(error)
            return nil
        }
    }
    
/*파이어 베이스에서 Email필드에 값을 불러오는데 서치 값이 없을 경우 빈 배열을 불러온다. 빈 배열일 경우 사용자가 적은 이메일 값이
 없고, 배열에 값이 존재할 경우 사용자가 사용하려는 이메일은 이미 존재함을 의미한다. */
    func isEmailSameExist(Email: String) async -> Bool? {
        do {
            let document = try await firestore.collection("users").whereField("email", isEqualTo: Email).getDocuments()
            if document.isEmpty {
                print("Email don't Exist")
                return false
            } else {
                print("Already exist Email")
                return true
            }
        } catch {
            print(error)
            return nil
        }
    }

    
    func createChatMessage(currentUser: User, chatUser: User, chatText: String) {
        
        guard let fromId = currentUser.id, let toId = chatUser.id else { return }
        
        let document = firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        
        try? document.setData(from: msg) { error in
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved current user sending message")
        }
        
        let recipientMessageDocument = firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                print(error)
                return
            }
            
            print("Recipient saved message as well")
        }
        
        persistRecentMessage(currentUser: currentUser, chatUser: chatUser, chatText: chatText)
    }
    
    func persistRecentMessage(currentUser: User, chatUser: User, chatText: String) {
        
        guard let fromId = currentUser.id, let toId = chatUser.id else { return }
        
        let document = firestore
            .collection("recentMessages")
            .document(fromId)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            "text": chatText,
            "fromId": fromId,
            "toId": toId,
            "profileImageUrl": chatUser.profileImageUrl,
            "chatUserName": chatUser.name
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        let recipientMessageDocument = firestore
            .collection("recentMessages")
            .document(toId)
            .collection("messages")
            .document(fromId)
        
        let recipientMessageData = [
            "timestamp": Timestamp(),
            "text": chatText,
            "fromId": toId,
            "toId": fromId,
            "profileImageUrl": currentUser.profileImageUrl,
            "chatUserName": currentUser.name
        ] as [String : Any]
        
        recipientMessageDocument.setData(recipientMessageData) { error in
            if let error = error {
                print("Failed to save recent message: \(error)")
                return
            }
        }
    }
    
    // 이건 왜 콜백함수지요?
    func downloadImage(at imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        let ref = storage.reference(forURL: imageUrl)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, _ in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    // MARK: - uploading single image and getting the image's download Url String
    func uploadImage(photo: UIImage, indexNum: Int) async -> String {
        guard let uid = auth.currentUser?.uid else { return ""}
        let photoNumber = String(indexNum)
        let fileName = uid + "_" + photoNumber
        do {
            let ref = storage.reference()
            guard let photoData = photo.jpegData(compressionQuality: 0.0) else { return "" }
            let imageRef = ref.child("ArtistPortfolio/\(fileName).jpg")
            
            let _ = try await imageRef
                .putDataAsync(photoData)
            let imageUrl = try await imageRef.downloadURL().absoluteString
            print("Success uploading Images")
            return imageUrl
        } catch {
            print("uploading Images error")
            return ""
        }
    }
    
    // MARK: - storing Artist Data to the Database
    func storeArtistInformation(_ artist: Artist) async {
        guard let uid = auth.currentUser?.uid else { return }
        do {
            let artistData = ["state": artist.state, "regions": artist.regions, "camera": artist.camera, "lens": artist.lens, "tags": artist.tags, "detailDescription": artist.detailDescription, "portfolioImageUrls":  artist.portfolioImageUrls.sorted(), "userInfo": artist.userInfo] as [String : Any]
            try await firestore.collection("artists").document(uid).setData(artistData)
            print("⭐️⭐️⭐️URL UPLOAD DONE ⭐️⭐️⭐️")
        } catch {
            print("error string Artist Model")
        }
    }
    
    func loadArtist(regions: [String], pages: Int) async -> (artists: [Artist], artistThumbnails: [ArtistThumbnail], cursor: QueryDocumentSnapshot?)? {
        do {
            var artists = [Artist]()
            var artistThumbnails = [ArtistThumbnail]()
            
            var querySnapshot: QuerySnapshot
            
            if regions == ["전체"] {
                querySnapshot = try await firestore.collection("artists").limit(to: pages).getDocuments()
            } else {
                querySnapshot = try await firestore.collection("artists").whereField("regions", arrayContainsAny: regions).limit(to: pages).getDocuments()
            }
            
            await querySnapshot.documents.asyncForEach({ snapshot in
                guard let artist = try? snapshot.data(as: Artist.self) else { return }
                let artistProfileImageView = try? await NetworkManager.shared.fetchOneImage(withURL: artist.userInfo["userProfileImageUrl"]!)
                let artistThumnailImageView = try? await NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls.first!)
                
                let artistThumbnail = ArtistThumbnail(
                    id: artist.id,
                    artistName: artist.userInfo["userName"] ?? "",
                    artistTag: "#\(artist.tags.joined(separator: "#"))",
                    artistProfileImageView: artistProfileImageView,
                    artistThumnailImageView: artistThumnailImageView
                )
                
                artists.append(artist)
                artistThumbnails.append(artistThumbnail)
            })
            
            let cursor = querySnapshot.count < pages ? nil : querySnapshot.documents.last
            
            return (artists, artistThumbnails, cursor)
        } catch {
            print("error to load Artist")
            return nil
        }
    }
    
    func continueArtist(regions: [String], cursor: DocumentSnapshot, pages: Int) async -> (artists: [Artist], artistThumbnails: [ArtistThumbnail], cursor: QueryDocumentSnapshot?)? {
        do {
            var artists = [Artist]()
            var artistThumbnails = [ArtistThumbnail]()
            
            var querySnapshot: QuerySnapshot
            
            if regions == ["전체"] {
                querySnapshot = try await firestore.collection("artists").start(afterDocument: cursor).limit(to: pages).getDocuments()
            } else {
                querySnapshot = try await firestore.collection("artists").whereField("regions", arrayContainsAny: regions).start(afterDocument: cursor).limit(to: pages).getDocuments()
            }
            
            await querySnapshot.documents.asyncForEach({ snapshot in
                guard let artist = try? snapshot.data(as: Artist.self) else { return }
                let artistProfileImageView = try? await NetworkManager.shared.fetchOneImage(withURL: artist.userInfo["userProfileImageUrl"]!)
                let artistThumnailImageView = try? await NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls.first!)
                
                let artistThumbnail = ArtistThumbnail(
                    id: artist.id,
                    artistName: artist.userInfo["userName"] ?? "",
                    artistTag: "#\(artist.tags.joined(separator: "#"))",
                    artistProfileImageView: artistProfileImageView,
                    artistThumnailImageView: artistThumnailImageView
                )
                
                artists.append(artist)
                artistThumbnails.append(artistThumbnail)
            })
            
            let cursor = querySnapshot.count < pages ? nil : querySnapshot.documents.last
            
            return (artists, artistThumbnails, cursor)
        } catch {
            print("error to continue Artist")
            return nil
        }
    }
}
