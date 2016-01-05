//Created by Insurance H3 Team
//
//GeoLocus App
//

import UIKit

class SettingsCustomCell: UITableViewCell {

    @IBOutlet weak var settingsValues: UILabel!
    
    @IBOutlet weak var settingsValuesSub: UILabel!
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
