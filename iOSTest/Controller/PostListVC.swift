//
//  ViewController.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import UIKit

class PostListVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var posts: [Post] = []
    private var currentPage = 1
    private let computationQueue = DispatchQueue(label: "com.myapp.computation", qos: .userInitiated)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialization()
    }
    
    // MARK: - intialization
    func intialization() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        fetchPosts()
        
        tableView?.addInfiniteScroll { [weak self] (scrollView) -> Void in
            guard let self = self else { return }
            fetchPosts(isPagination: true)
        }
    
    }
    
    // MARK: - FetchPosts from API
    private func fetchPosts(isPagination: Bool = false) {
        if !isPagination {
            DispatchQueue.main.async{
                _ = MBProgressHUD.showHUDAddedTo(view: self.view, animated: true)
            }
        }
        NetworkManager.shared.fetchPosts(page: currentPage) { [weak self] posts, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideHUDForView(view: self.view, animated: true)
                self.tableView.finishInfiniteScroll()
            }
            
            if let posts = posts {
                currentPage += 1
                self.posts += posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.computeAdditionalDetails()
                }
            } else if let error = error {
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    // MARK: - Compute Additional Details
    private func computeAdditionalDetails() {
        computationQueue.async { [weak self] in
            guard let self = self else { return }
            let startTime = CFAbsoluteTimeGetCurrent()
            for index in 0..<self.posts.count {
                // Simulate heavy computation for additional details
                self.posts[index].additionalDetails = self.computeDetails(for: self.posts[index])
            }
            let endTime = CFAbsoluteTimeGetCurrent()
            print("Computation time: \(endTime - startTime) seconds")
        }
    }
    
    private func computeDetails(for post: Post) -> String {
        // Simulate heavy computation
        Thread.sleep(forTimeInterval: 0.1) // Simulate heavy computation time
        return "Additional details for post \(post.id)"
    }
}

// MARK: - UITableViewDataSource methods
extension PostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell",
                                                       for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        cell.setUpPostUI(data: posts[indexPath.row])
        return cell
    }
}
// MARK: - UITableViewDelegate methods
extension PostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailVC") as? PostDetailVC{
            vc.post = posts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
