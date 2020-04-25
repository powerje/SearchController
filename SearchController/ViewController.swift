import UIKit

class ViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Scope 1", "Scope 2"]
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsScopeBar = true
        navigationItem.searchController = searchController
    }

    override func viewDidLayoutSubviews() {
        defer { super.viewDidLayoutSubviews() }
        guard #available(iOS 13.0, *) else {
            searchController.hidesNavigationBarDuringPresentation = false
            // The cancel button has to go entirely, otherwise the scopes disappear _forever_
            // upon canceling - regardless of the setting above.
            searchController.searchBar.showsCancelButton = false
            // Have to make it active otherwise it overlaps with the cells of the UITableView.
            searchController.isActive = true
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }

    // HAX: this hides and shows the scope bar appropriately to allow
    // the system animation of the search bar to complete properly.
    private var lastContentOffset = CGFloat(0)
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard #available(iOS 13, *) else { return }
        let searchBar = searchController.searchBar

        if lastContentOffset > scrollView.contentOffset.y {
            // Scrolling down, show the scope bar.
            if !searchBar.showsScopeBar && searchBar.frame.size.height > 44 {
                searchBar.showsScopeBar = true
            }
        } else if lastContentOffset < scrollView.contentOffset.y {
            // Scrolling up, hide the scope bar to allow the searchBar to collapse
            // completely.
            if searchBar.showsScopeBar && searchBar.frame.size.height <= 44 {
                searchBar.showsScopeBar = false
            }
        }

        lastContentOffset = scrollView.contentOffset.y
    }

}
