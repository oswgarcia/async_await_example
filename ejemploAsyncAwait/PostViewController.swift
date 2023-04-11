//
//  PostViewController.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 11/04/23.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var posts: [PostModel] = []
    var comments: [[CommentsModel]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Posts"
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.cellLayoutMarginsFollowReadableWidth = true
        
        tableView?.reloadData()
    }
    
}
extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de secciones en la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Número de filas en la sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Celda de la tabla para cada fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.body
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postID = self.posts[indexPath.row].id
        let filteredComments = comments.flatMap { $0 }.filter { $0.postID == postID }
        
        let commentsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        commentsViewController.comments = filteredComments
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
