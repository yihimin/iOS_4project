//
//  ViewController.swift
//  MovieLHM
//
//  Created by Induk-cs-1 on 2025/05/08.
//
import UIKit

struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult
}
struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList] }
struct DailyBoxOfficeList : Codable { let movieNm : String
    let audiCnt : String
    let audiAcc : String
    let rank : String
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var movieData  : MovieData?
    @IBOutlet weak var table : UITableView!
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=6e3285dc92169992324517f12b2e7027&targetDt="
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        movieURL = movieURL + makeYesterdayString()
        getData()
    }
    func makeYesterdayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return formatter.string(from: yesterday)
    }
    
    func getData(){
        guard let url = URL(string: movieURL) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let JSONdata = data else { return }
            let _ = String(data: JSONdata, encoding: .utf8)
            //print(dataString!)
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(MovieData.self, from: JSONdata)
                //print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                //print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].audiAcc)
                self.movieData = decodedData
                DispatchQueue.main.async{
                    self.table.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        cell.audiAccumulate.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc
        cell.audiCount.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

