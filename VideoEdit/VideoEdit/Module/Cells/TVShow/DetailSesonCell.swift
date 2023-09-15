import UIKit

class DetailSesonCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectEpisode: ((_ episodes: TelevisionEpisode) -> Void)?
    
    var episodes: [TelevisionEpisode] = [] {
        didSet {
            if (tableView != nil) {
                tableView.reloadData()
            }
        }
    }
    
    var backdrop: URL? {
        didSet {
            if (tableView != nil) {
                tableView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: DetailSesonItemCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailSesonItemCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailSesonItemCell.cellId) as! DetailSesonItemCell
        cell.episode = episodes[indexPath.row]
        if episodes[indexPath.row].still_path == "" {
            cell.backdrop = backdrop
        }
        cell.selectEpisode = { episode in
            if let selectEpisode = self.selectEpisode {
                selectEpisode(episode)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectEpisode = self.selectEpisode {
            selectEpisode(episodes[indexPath.row])
        }
    }
    
}
