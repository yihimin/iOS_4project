//
//  ViewController.swift
//  MovieLHM
//
//  Created by Induk-cs-1 on 2025/05/08.
//
import UIKit

let name = ["야당1", "야당2", "야당3", "야당4", "야당5"]
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table : UITableView!
    let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=6e3285dc92169992324517f12b2e7027&targetDt=20250507"
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        getData()
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
            let dataString = String(data: JSONdata, encoding: .utf8)
            print(dataString!)
        }
            task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.movieName.text = name[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

}

