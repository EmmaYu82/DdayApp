import UIKit

class ViewTheDay: UIViewController, UITableViewDataSource{
    @IBOutlet weak var tableview: UITableView!
    
    var arr : [TheDayInfo] = []
    var core = Core()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get DB Data
        core.CreateDB()
        arr = core.GetTheDayDB()
        
         self.tableview.dataSource = self
         self.tableview.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeatureCell", for: indexPath) as! TableTableViewCell
        
        cell.TheStartDay.text = arr[indexPath.row].startDay
        cell.TheTerms.text = arr[indexPath.row].term
        cell.TheCycle.text = arr[indexPath.row].cycle
        return cell
    }
}
