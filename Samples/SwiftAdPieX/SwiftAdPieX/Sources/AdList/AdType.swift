import UIKit

enum AdType {
    case interstitial(String)
    case rewarded(String)
    case native(String)

    var viewController: UIViewController {
        switch self {
        case .interstitial(let slotId): return InterstitialAdViewController(slotId: slotId)
        case .rewarded(let slotId): return RewardedAdViewController(slotId: slotId)
        case .native(let slotId): return NativeAdViewController(slotId: slotId)
        }
    }
}
