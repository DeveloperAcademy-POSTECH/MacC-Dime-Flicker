////
////  MessageViewController.swift
////  Flicker
////
////  Created by COBY_PRO on 2022/10/24.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
//final class MessageViewController: BaseViewController {
//    
//    // MARK: - property
//    
//    lazy var channelTableView = UITableView().then {
//        $0.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.className)
//        $0.delegate = self
//        $0.dataSource = self
//        
//        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//    var channels = [Channel]()
//    
//    // MARK: - func
//    
//    override func render() {
//        view.addSubview(channelTableView)
//        channelTableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        channels = getChannelMocks()
//    }
//    
//    override func setupNavigationBar() {
//        super.setupNavigationBar()
//
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.largeTitleDisplayMode = .automatic
//        navigationItem.leftBarButtonItem = nil
//        
//        title = "메세지"
//    }
//}
//
//extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return channels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.className, for: indexPath) as! MessageTableViewCell
//        
//        cell.selectionStyle = . none
//        cell.chatUserNameLabel.text = channels[indexPath.row].userName
//        cell.chatDateLabel.text = channels[indexPath.row].chatDate
//        cell.chatLastLabel.text = channels[indexPath.row].chatLast
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let channel = channels[indexPath.row]
//        let viewController = MessageRoomViewController(channel: channel)
//        viewController.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//}
