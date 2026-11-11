#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class APAppOpenAdService;

/// DidFailToShow 오류의 userInfo에서 이 값이 YES이면 중복 요청 실패이며, 기존 요청은 계속 진행된다.
FOUNDATION_EXPORT NSString * const APAppOpenAdDuplicateRequestKey;

@protocol APAppOpenAdDelegate <NSObject>
@optional
/// 표시를 시도하기 직전에 호출한다. 실제로 보이지 못하면 DidFailToShow로 끝날 수 있다.
- (void)appOpenAdWillPresentScreen:(APAppOpenAdService *)ad;
- (void)appOpenAdDidPresentScreen:(APAppOpenAdService *)ad;
- (void)appOpenAdDidRecordImpression:(APAppOpenAdService *)ad;
/// 유효한 link가 있는 광고를 탭할 때 메인 스레드에서 호출한다. 개인정보 옵션 탭은 제외한다.
- (void)appOpenAdDidClick:(APAppOpenAdService *)ad;
- (void)appOpenAdWillDismissScreen:(APAppOpenAdService *)ad;
/// 실제 표시된 광고가 화면에서 제거된 뒤 한 번 호출한다. 이 시점에 앱 흐름을 이어간다.
- (void)appOpenAdDidDismissScreen:(APAppOpenAdService *)ad;
/// 광고를 표시하지 못한 경우 호출한다. 표시 전 사라진 광고도 포함하며 DidDismiss와 구분한다.
/// APAppOpenAdDuplicateRequestKey가 YES인 중복 실패에서는 기존 화면 상태와 delegate를 유지한다.
- (void)appOpenAdDidFailToShowAd:(APAppOpenAdService *)ad withError:(NSError *)error;
@end

/// 앱 수명 동안 유지되는 오프닝 광고 서비스. delegate는 메인 스레드에서 변경한다.
@interface APAppOpenAdService : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithSlotId:(NSString *)slotId NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

/// 다음 새 광고 요청에 적용할 파라미터를 설정한다. floorPrice는 USD 기준이다.
/// present 전에 설정하며, 빈 키/값과 지원하지 않는 키는 무시한다.
- (void)setExtraParameterForKey:(NSString *)key value:(NSString *)value;

/// 서비스는 delegate를 보유하지 않는다. 화면 종료 후에도 콜백이 필요하면 수명이 긴 객체를 지정한다.
@property (nonatomic, weak, nullable) id<APAppOpenAdDelegate> delegate;

/// 캐시 광고를 표시한다. 광고가 없으면 실패를 알리고 다음 호출을 위해 로드한다.
/// 진행 중 중복 호출은 기존 요청을 유지하고 DidFailToShow를 전달하며, 추가 로드는 요청하지 않는다.
- (void)present:(NSString *)adUnitId viewController:(nullable UIViewController *)viewController;

/// 기존 present와 동일하게 동작하며, 실제 노출 시 paidEvent를 메인 스레드에서 한 번 호출한다.
/// paidEvent에는 광고의 price(eCPM) 값을 전달한다.
- (void)present:(NSString *)adUnitId
 viewController:(nullable UIViewController *)viewController
      paidEvent:(void (^ _Nullable)(double value))paidEvent;

@end

NS_ASSUME_NONNULL_END
