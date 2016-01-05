//Created by Insurance H3 Team
//
//GeoLocus App
//

import UIKit

class LBCustomCell: UITableViewCell {
    
  
    @IBOutlet weak var lapLabel: UILabel!
    
    @IBOutlet weak var processDateLabel: UILabel!
    
    @IBOutlet weak var distanceDrivenLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
