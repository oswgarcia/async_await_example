//
//  ViewController.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 15/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [UserModel] = []
    var posts: [[PostModel]] = [[]]
    var comments: [[CommentsModel]] = [[]]
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        // Configuramos la tabla
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
         //callPostWithCallbacks()
        
//        Task{
//            do {
//                await callPostsWithAsyncAwait()
//            }
//        }
        
        Task{
            do {
                await callPostsWithMixAsyncAwaitAndCallback()
            }
        }
        
        
    }
    
    
    func callPostWithCallbacks() {
        
        // Obtener la lista de usuarios
        viewModel.fetchUsers { [weak self] (users, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let users = users else {
                print("No users found.")
                return
            }
            self?.users = users
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
            // Para cada usuario, obtener la lista de posts
            for user in users {
                self?.viewModel.fetchPosts(by: user) { [weak self] (posts, error) in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let userPosts = posts else {
                        print("No posts found for user \(user.name).")
                        return
                    }
                    self?.posts.append(userPosts)
                    
                    // Para cada post, obtener la lista de comentarios
                    for post in userPosts {
                        self?.viewModel.fetchComments(by: post) { (comments, error) in
                            if let error = error {
                                print("Error fetching comments: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let comments = comments else {
                                print("No comments found for post \(post.title).")
                                return
                            }
                            
                            self?.comments.append(comments)
                            for comment in comments {
                                print("Comment by \(comment.name): \(comment.body)")
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    
        func callPostsWithAsyncAwait() async {
    
            // Llamamos a la función fetchPosts utilizando async/await
    
            do {
                // Obtener los usuarios
                users = try await viewModel.fetchUsers()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
    
                // Obtener los posts de cada usuario
                for user in users {
                    let userPosts = try await viewModel.fetchPosts(by: user)
                    posts.append(userPosts)
                    
                    // Obtener los comentarios de cada post
                    for post in userPosts {
                        let comments = try await viewModel.fetchComments(by: post)
                        self.comments.append(comments)
                    }
                }
            } catch {
                print(error)
            }
        }
    
    func callPostsWithMixAsyncAwaitAndCallback() async {

        // Llamamos a la función fetchPosts utilizando async/await

        do {
            // Obtener los usuarios
            users = try await viewModel.fetchUsersMix()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            // Obtener los posts de cada usuario
            for user in users {
                let userPosts = try await viewModel.fetchPosts(by: user)
                posts.append(userPosts)
                
                // Obtener los comentarios de cada post
                for post in userPosts {
                    let comments = try await viewModel.fetchComments(by: post)
                    self.comments.append(comments)
                }
            }
        } catch {
            print(error)
        }
    }
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de secciones en la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Número de filas en la sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // Celda de la tabla para cada fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let userID = self.users[indexPath.row].id
        let filteredPosts = posts.flatMap { $0 }.filter { $0.userID == userID }
        
        let filteredPostComments = filteredPosts.map { post in
            comments.flatMap { $0.filter { $0.postID == post.id } }
        }
       
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        postViewController.posts = filteredPosts
        postViewController.comments = filteredPostComments
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
}
