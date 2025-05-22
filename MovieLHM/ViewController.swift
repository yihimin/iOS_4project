import UIKit

// MARK: - 모델 정의
struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {
    let movieNm: String
    let audiCnt: String
    let audiAcc: String
    let rank: String
}

// MARK: - ViewController
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var movieData: MovieData?
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=6e3285dc92169992324517f12b2e7027&targetDt="

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        movieURL += makeYesterdayString()
        getData()
    }

    // MARK: - 날짜 생성
    func makeYesterdayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return "날짜오류"
        }
        return formatter.string(from: yesterday)
    }

    // MARK: - 데이터 패칭
    func getData() {
        guard let url = URL(string: movieURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("네트워크 오류:", error)
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(MovieData.self, from: data)
                DispatchQueue.main.async {
                    self.movieData = decoded
                    self.table.reloadData()
                }
            } catch {
                print("디코딩 실패:", error)
            }
        }.resume()
    }

    // MARK: - TableView 데이터소스
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData?.boxOfficeResult.dailyBoxOfficeList.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailViewController
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        dest.movieName = (movieData?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "🍿 박스오피스 (영화진흥위원회 제공: \(makeYesterdayString())) 🍿"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "made by yihimin"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyTableViewCell,
            let movie = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.movieName.text = "[\(movie.rank)위] \(movie.movieNm)"
        cell.movieName.adjustsFontSizeToFitWidth = true
        cell.movieName.minimumScaleFactor = 0.5
        cell.movieName.numberOfLines = 2
        cell.movieName.lineBreakMode = .byTruncatingTail

        cell.audiCount.text = "어제: \(formatNumber(movie.audiCnt))명"
        cell.audiAccumulate.text = "누적: \(formatNumber(movie.audiAcc))명"

        return cell
    }

    // MARK: - 숫자 포맷 유틸
    func formatNumber(_ string: String) -> String {
        guard let number = Int(string) else { return string }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: number) ?? string
    }
}

