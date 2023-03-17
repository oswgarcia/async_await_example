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
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuramos la tabla
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        callPostWithCallbacks()
        
        //        Task{
        //            do {
        //                await callPostsWithAsyncAwait()
        //            }
        //        }
        
        
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
                    
                    guard let posts = posts else {
                        print("No posts found for user \(user.name).")
                        return
                    }
                    
                    // Para cada post, obtener la lista de comentarios
                    for post in posts {
                        self?.viewModel.fetchComments(by: post) { (comments, error) in
                            if let error = error {
                                print("Error fetching comments: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let comments = comments else {
                                print("No comments found for post \(post.title).")
                                return
                            }
                            
                            // Imprimir los comentarios
                            for comment in comments {
                                print("Comment by \(comment.name): \(comment.body)")
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    
    //    func callPostsWithAsyncAwait() async  {
    //
    //        // Llamamos a la función fetchPosts utilizando async/await
    //
    //        do {
    //            // Obtener los usuarios
    //            users = try await viewModel.fetchUsers()
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //
    //            // Obtener los posts de cada usuario
    //            for user in users {
    //                let posts = try await viewModel.fetchPosts(by: user)
    //
    //                // Obtener los comentarios de cada post
    //                for post in posts {
    //                    let comments = try await viewModel.fetchComments(by: post)
    //
    //                    // Hacer algo con los comentarios, por ejemplo imprimirlos
    //                    print(comments)
    //                }
    //            }
    //        } catch {
    //            print(error)
    //        }
    //
    //
    //    }
    
}
extension ViewController: UITableViewDataSource {
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
    
}
