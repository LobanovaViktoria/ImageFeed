//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 02.02.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func switchToSplashViewController()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: presenter?.avatarURL(), placeholder: UIImage(named: "placeholder"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = .boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userLogin: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userStatus: UILabel = {
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
        button.accessibilityIdentifier = "logoutButton"
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayout()
        view.backgroundColor = .ypBlack
        updateAvatar()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard self != nil else { return }
                self?.updateAvatar()
            }
    }
    
    func updateAvatar() {
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: presenter?.avatarURL(), placeholder: UIImage(named: "placeholder"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func updateProfileDetails() {
        var profileDetails: [String]?
        profileDetails = presenter?.updateProfileDetails()
        userName.text = profileDetails?[0]
        userLogin.text = profileDetails?[1]
        userStatus.text = profileDetails?[2]
    }
    
    @objc
    private func didTapLogoutButton() {
        showAlert()
    }
 
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.presenter?.logout()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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

