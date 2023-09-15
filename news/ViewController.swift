import UIKit
import SnapKit
import Alamofire
struct NewsArticle: Decodable {
    let title: String
    let description: String?
    let urlToImage: String?
}
struct NewsResponse: Decodable {
    let articles: [NewsArticle]
}
class NewsService {
    static let shared = NewsService()
    private let apiKey = "3c55a2cdcbe8495b8a1c0207fe3e591c"
    private let baseUrl = "https://newsapi.org/v2/top-headlines"
    func fetchTopHeadlines(completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        let parameters: [String: Any] = [
            "country": "ru",
            "apiKey": apiKey
        ]
        AF.request(baseUrl, parameters: parameters).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(.success(newsResponse.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
class HomViewController: UIViewController, UISearchBarDelegate {
    let titleLabel = UILabel()
    var newsArticles: [NewsArticle] = []
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleLabel.text = "Главная"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchNews()
    }
    func fetchNews() {
        NewsService.shared.fetchTopHeadlines { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsArticles = articles
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch news: \(error)")
            }
        }
    }
}
extension HomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = newsArticles[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
}
class ZakViewController: UIViewController {
    let titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Закладки"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        view.backgroundColor = .systemBackground
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
    }
}
class TraViewController: UIViewController {
    let titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Переводчик"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        view.backgroundColor = .systemBackground
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
    }
}
class WeaViewController: UIViewController {
    let titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Погода"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        view.backgroundColor = .systemBackground
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
    }
}
class AccViewController: UIViewController {
    let titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Аккаунт"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        view.backgroundColor = .systemBackground
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
    }
}
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homViewController = HomViewController()
        let zakViewController = ZakViewController()
        let traViewController = TraViewController()
        let weaViewController = WeaViewController()
        let accViewController = AccViewController()
        homViewController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        zakViewController.tabBarItem = UITabBarItem(title: "Закладки", image: UIImage(systemName: "star"), tag: 1)
        traViewController.tabBarItem = UITabBarItem(title: "Переводчик", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 2)
        weaViewController.tabBarItem = UITabBarItem(title: "Погода", image: UIImage(systemName: "cloud.sun.rain"), tag: 3)
        accViewController.tabBarItem = UITabBarItem(title: "Аккаунт", image: UIImage(systemName: "person"), tag: 4)
        let viewControllers = [homViewController, zakViewController, traViewController, weaViewController, accViewController]
        self.viewControllers = viewControllers
    }
}
