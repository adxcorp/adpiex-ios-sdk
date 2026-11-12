#import "SplashViewController.h"
#import "AppDelegate.h"
#import "AdListViewController.h"
#import "SplashLoadingViewController.h"

@interface SplashViewController ()
@property (nonatomic) BOOL started;
@property (nonatomic) BOOL sdkReady;
@property (nonatomic) BOOL finished;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.started) { return; }
    self.started = YES;
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    __weak typeof(self) weakSelf = self;
    [appDelegate waitForAdPieSDKInitialization:^(BOOL initialized) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) { return; }
        if (!initialized) {
            [self showMain];
            return;
        }
        self.sdkReady = YES;
        [self showLoadingIfNeeded];
    }];
}

- (void)setUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"AdPieX\nSplash";
    label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:)
                                                name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didBecomeActive:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showLoadingIfNeeded];
    });
}

- (void)showLoadingIfNeeded {
    if (!self.sdkReady || self.finished || !self.view.window ||
        UIApplication.sharedApplication.applicationState != UIApplicationStateActive ||
        self.view.window.windowScene.activationState != UISceneActivationStateForegroundActive) { return; }
    self.finished = YES;

    [self.navigationController setViewControllers:@[[[SplashLoadingViewController alloc] init]] animated:NO];
}

- (void)showMain {
    if (self.finished) { return; }
    self.finished = YES;
    [self.navigationController setViewControllers:@[[[AdListViewController alloc] init]] animated:NO];
}

@end
