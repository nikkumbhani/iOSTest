//
//  PostDetailVC.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import UIKit

class PostDetailVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblBody: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    var post: Post?
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialization()
    }
    
    // MARK: - intialization
    func intialization() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        setupUI()
        fetchPostComments()
    }
    
    func setupUI() {
        lblTitle.text = post?.title
        lblBody.text = post?.body
    }
    
    // MARK: - FetchPosts from API
    private func fetchPostComments() {
        DispatchQueue.main.async{
            _ = MBProgressHUD.showHUDAddedTo(view: self.view, animated: true)
        }
        
        NetworkManager.shared.fetchComments(forPostId: 1) { [weak self] comments, error in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideHUDForView(view: self.view, animated: true)
            }
            
            if let error = error {
                print("Error fetching comments: \(error)")
            } else if let comments = comments {
                self.comments = comments
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource methods
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell",
                                                       for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        cell.setUpCommentsUI(data: comments[indexPath.row])
        return cell
    }
}
