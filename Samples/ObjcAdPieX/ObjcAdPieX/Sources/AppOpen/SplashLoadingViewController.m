#import "SplashLoadingViewController.h"
#import "AdListViewController.h"
#import <AdPieXFramework/AdPieSDK.h>

@interface SplashLoadingViewController () <APAppOpenAdDelegate>
@property (nonatomic) BOOL requested;
@property (nonatomic, strong) APAppOpenAdService *appOpenAdService;
@end

@implementation SplashLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNotification];
    [self setAppOpenAd];
}

- (void)setUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"AdPieX\nLoading...";
    label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    spinner.color = UIColor.systemBlueColor;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [spinner.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:16]
    ]];
}

- (void)setNotification {
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
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentAppOpenAdIfNeeded];
    });
}

- (void)setAppOpenAd {
    self.appOpenAdService = [APAppOpenAdService sharedInstance];
    self.appOpenAdService.delegate = self;
}

- (void)presentAppOpenAdIfNeeded {
    if (self.requested || !self.view.window ||
        UIApplication.sharedApplication.applicationState != UIApplicationStateActive ||
        self.view.window.windowScene.activationState != UISceneActivationStateForegroundActive) { return; }
    self.requested = YES;

    [self.appOpenAdService present:@"6af43f8fbbfa519f16c5f264" viewController:self paidEvent:^(double value) {
        NSLog(@"[AppOpen] paidEvent, eCPM: %f", value);
    }];
}

- (void)waitAndShowMain {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [self waitAndShowMain];
}

- (void)appOpenAdDidFailToShowAd:(APAppOpenAdService *)ad withError:(NSError *)error {
    if ([error.userInfo[APAppOpenAdDuplicateRequestKey] boolValue]) { return; }
    NSLog(@"[AppOpen] 표시 실패: %@", error);
    [self waitAndShowMain];
}

@end
