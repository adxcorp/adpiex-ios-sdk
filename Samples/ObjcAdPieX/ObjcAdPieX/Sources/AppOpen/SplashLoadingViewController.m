#import "SplashLoadingViewController.h"
#import "AdListViewController.h"
#import <AdPieXFramework/AdPieSDK.h>

@interface SplashLoadingViewController () <APAppOpenAdDelegate>
@property (nonatomic) BOOL requested;
@end

@implementation SplashLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"AdPieX\nSplashLoading";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [spinner.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:16]
    ]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:)
                                                name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentAppOpenAdIfNeeded];
}

- (void)didBecomeActive:(NSNotification *)notification {
    // 화면 전환 직후 앱이 비활성화되었다면 활성화 시 표시한다.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentAppOpenAdIfNeeded];
    });
}

- (void)presentAppOpenAdIfNeeded {
    if (self.requested || !self.view.window ||
        UIApplication.sharedApplication.applicationState != UIApplicationStateActive ||
        self.view.window.windowScene.activationState != UISceneActivationStateForegroundActive) { return; }
    self.requested = YES;

    APAppOpenAdService *service = [APAppOpenAdService sharedInstance];
    service.delegate = self;
    // 캐시 광고를 표시하고 다음 광고를 로드한다. 별도 load 호출은 필요하지 않다.
    [service present:@"6af43f8fbbfa519f16c5f264" viewController:self paidEvent:^(double value) {
        NSLog(@"[AppOpen] paidEvent, eCPM: %f", value);
    }];
}

- (void)waitAndShowMain {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showMain];
    });
}

- (void)showMain {
    UINavigationController *navigationController = self.navigationController;
    if (navigationController.viewControllers.firstObject != self) { return; }
    [navigationController setViewControllers:@[[[AdListViewController alloc] init]] animated:NO];
}

#pragma mark - APAppOpenAdDelegate

- (void)appOpenAdDidDismissScreen:(APAppOpenAdService *)ad {
    [self showMain];
}

- (void)appOpenAdDidFailToShowAd:(APAppOpenAdService *)ad withError:(NSError *)error {
    if ([error.userInfo[APAppOpenAdDuplicateRequestKey] boolValue]) { return; }
    NSLog(@"[AppOpen] 표시 실패: %@", error);
    // 캐시가 없는 첫 실행도 여기에 해당하며, SDK는 다음 실행용 광고를 로드한다.
    [self waitAndShowMain];
}

@end
