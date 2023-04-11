//
//  CommentsViewController.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 11/04/23.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    var comments: [CommentsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.cellLayoutMarginsFollowReadableWidth = true
        
        tableView?.reloadData()
    }
    
}
extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de secciones en la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Número de filas en la sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // Celda de la tabla para cada fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.body
        return cell
    }
  
}
