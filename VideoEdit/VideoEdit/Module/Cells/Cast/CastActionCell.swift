import UIKit

class CastActionCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    static let height: CGFloat = UITableView.automaticDimension
    
    @IBOutlet weak var collectionView: UITableView!
    @IBOutlet weak var lbViewMore: UILabel!
    @IBOutlet weak var imageViewMore: UIImageView!
    
    var actings: [ActingHistory] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var isCollapsed: Bool = false {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
            if isCollapsed == true {
                lbViewMore.text = "View more"
                imageViewMore.image = UIImage(named: "ic_viewmore")
            } else {
                lbViewMore.text = "View less"
                imageViewMore.image = UIImage(named: "ic_viewless")
            }
        }
    }
    var onChangedState: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: CastActionItemCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastActionItemCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewMore(_ sender: Any) {
        onChangedState?()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCollapsed == true {
            return actings.count > 7 ? 7 : actings.count
        } else {
            return actings.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CastActionItemCell.cellId) as! CastActionItemCell
        cell.data = actings[indexPath.row]
        if indexPath.row == 0 {
            cell.rowType = .top
        } else if isCollapsed == true {
            if actings.count > 7 {
                if indexPath.row == 6 {
                    cell.rowType = .bottom
                } else {
                    cell.rowType = .none
                }
            } else {
                if indexPath.row == (actings.count - 1) {
                    cell.rowType = .bottom
                } else {
                    cell.rowType = .none
                }
            }
        } else {
            if indexPath.row == (actings.count - 1) {
                cell.rowType = .bottom
            } else {
                cell.rowType = .none
            }
        }
        return cell
    }
}
