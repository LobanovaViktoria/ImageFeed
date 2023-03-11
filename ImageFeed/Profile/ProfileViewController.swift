//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = .boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userLogin: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userStatus: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayout()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO обновить аватар, используя KingFisher
    }
    
//    open func addObserver(
//        forName name: NSNotification.Name?,
//        object obj: Any?,
//        queue: OperationQueue?,
//        using block: @escaping (Notification) -> Void
//    ) -> NSObjectProtocol
        
        private func updateProfileDetails() {
        userName.text = profileService.profile?.name
        userLogin.text = profileService.profile?.loginName
        userStatus.text = profileService.profile?.bio
       // imageView.image = UIIM
    }
    
    @objc
    private func didTapLogoutButton() {
        print("didTapLogoutButton")
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(userName)
        view.addSubview(userLogin)
        view.addSubview(userStatus)
        view.addSubview(logoutButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            userName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            userLogin.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            userStatus.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8),
            userStatus.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}

