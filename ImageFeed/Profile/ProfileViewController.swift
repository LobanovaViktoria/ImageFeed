//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let profileImage = UIImage(named: "photo")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userLogin: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userStatus: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!!!"
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
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        userName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        userName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8).isActive = true
        userLogin.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        userStatus.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8).isActive = true
        userStatus.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}
