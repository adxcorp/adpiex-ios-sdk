import UIKit
import AdPieXFramework

final class AdPieTableViewCell: UITableViewCell {
    
    @IBOutlet var nativeAdView: APNativeAdView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
