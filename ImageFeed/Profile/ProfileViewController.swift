//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Viktoria Lobanova on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //    @IBOutlet private var loginLable: UILabel!
    //    @IBOutlet private var statusLable: UILabel!
    //    @IBOutlet private var userPhotoImage: UIImageView!
    //    @IBOutlet private var userNameLable: UILabel!
    //    @IBOutlet private var logoutButton: UIButton!
    //    @IBAction private func didTapLogoutButton() { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let profileImage = UIImage(named: "photo")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = .ypWhite
        userName.font = .systemFont(ofSize: 23)
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userName)
        
        userName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        userName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let userLogin = UILabel()
        userLogin.text = "@ekaterina_nov"
        userLogin.textColor = .ypGray
        userLogin.font = .systemFont(ofSize: 13)
        userLogin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userLogin)
        
        userLogin.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8).isActive = true
        userLogin.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let userStatus = UILabel()
        userStatus.text = "Hello, world!!!"
        userStatus.textColor = .ypWhite
        userStatus.font = .systemFont(ofSize: 13)
        userStatus.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userStatus)
        
        userStatus.topAnchor.constraint(equalTo: userLogin.bottomAnchor, constant: 8).isActive = true
        userStatus.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let button = UIButton.systemButton(
            with: UIImage(named: "logOut")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() { }
    
}
