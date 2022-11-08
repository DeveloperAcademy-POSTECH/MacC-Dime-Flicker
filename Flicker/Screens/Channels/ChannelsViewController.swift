//
//  ChannelsViewController.swift
//  CobyTalk
//
//  Created by Coby Kim on 2022/10/30.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import SnapKit
import Then

final class ChannelsViewController: BaseViewController {
    
    private var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?

    deinit {
        firestoreListener?.remove()
    }
    
    // MARK: - property
    
    private lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - func
    
    override func render() {
        view.addSubview(channelTableView)
        
        channelTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fetchRecentMessages()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        title = "메세지"
    }
    
    private func fetchRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let firestoreReference = FirebaseManager.shared.firestore
            .collection("recentMessages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp", descending: true)
        
        firestoreListener = firestoreReference.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error listening for recent messages: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func addRecentMessageToTable(_ recentMessage: RecentMessage) {
        let docId = recentMessage.id
        
        if recentMessages.contains(where: { $0.id == docId }) { return }
        recentMessages.append(recentMessage)
        
        guard let index = recentMessages.firstIndex(where: { $0.id == docId }) else { return }
        
        channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateRecentMessageInTable(_ recentMessage: RecentMessage) {
        let docId = recentMessage.id
        guard let index = recentMessages.firstIndex(where: { $0.id == docId }) else { return }
        
        recentMessages[index] = recentMessage
        channelTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeRecentMessageFromTable(_ recentMessage: RecentMessage) {
        let docId = recentMessage.id
        guard let index = recentMessages.firstIndex(where: { $0.id == docId }) else { return }
        
        recentMessages.remove(at: index)
        channelTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let recentMessage = try? change.document.data(as: RecentMessage.self) else {
            return
        }
        
        switch change.type {
        case .added:
            addRecentMessageToTable(recentMessage)
        case .modified:
            updateRecentMessageInTable(recentMessage)
        case .removed:
            removeRecentMessageFromTable(recentMessage)
        }
    }
    
    @objc private func signOut() {
        try? Auth.auth().signOut()
        
        let navigationController = UINavigationController(rootViewController: LogInViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

extension ChannelsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.className, for: indexPath) as! ChannelTableViewCell
        
        cell.selectionStyle = .none
        
        cell.chatUserImageView.load(url: URL(string: recentMessages[indexPath.row].profileImageUrl)!)
        cell.chatUserNameLabel.text = recentMessages[indexPath.row].chatUserName
        cell.chatDateLabel.text = recentMessages[indexPath.row].timeAgo
        
        let chatLastText = recentMessages[indexPath.row].text
        cell.chatLastLabel.text = chatLastText.count > 20 ? "\(chatLastText.prefix(20))..." : chatLastText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentMessage = recentMessages[indexPath.row]
        let viewController = ChatViewController(name: recentMessage.chatUserName, fromId: recentMessage.fromId, toId: recentMessage.toId)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
