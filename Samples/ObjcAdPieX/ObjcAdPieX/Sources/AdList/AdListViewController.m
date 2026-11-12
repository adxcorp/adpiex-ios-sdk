#import "AdListViewController.h"
#import "AdListCell.h"
#import "AdMenuItem.h"
#import "InterstitialAdViewController.h"
#import "RewardedAdViewController.h"
#import "NativeAdViewController.h"

@interface AdListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<AdMenuItem *> *items;
@end

@implementation AdListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    
    self.items = @[
        
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Image, Portrait" subtitle:@"전면 광고 - 이미지, 세로" actionBlock:^{
            return [[InterstitialAdViewController alloc] initWithSlotId:@"697c1394a56addbb35024c04"];
        }],
        
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Image, Landscape" subtitle:@"전면 광고 - 이미지, 가로" actionBlock:^{
            return [[InterstitialAdViewController alloc] initWithSlotId:@"697c13b7a56addbb35024c06"];
        }],
        
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Video, Portrait" subtitle:@"전면 광고 - 비디오, 세로" actionBlock:^{
            return [[InterstitialAdViewController alloc] initWithSlotId:@"697c173da56addbb35024c0d"];
        }],
        
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Video, Landscape" subtitle:@"전면 광고 - 비디오, 가로" actionBlock:^{
            return [[InterstitialAdViewController alloc] initWithSlotId:@"697c1792a56addbb35024c0f"];
        }],
        
        [AdMenuItem itemWithTitle:@"Rewarded Ad - Portrait" subtitle:@"리워드 광고 - 세로" actionBlock:^{
            return [[RewardedAdViewController alloc] initWithSlotId:@"697c1d6ea56addbb35024c29"];
        }],
        
        [AdMenuItem itemWithTitle:@"Rewarded Ad - Landscape" subtitle:@"리워드 광고 - 가로" actionBlock:^{
            return [[RewardedAdViewController alloc] initWithSlotId:@"697c1d94a56addbb35024c2b"];
        }],
        
        [AdMenuItem itemWithTitle:@"Native Ad" subtitle:@"네이티브 광고" actionBlock:^{
            return [[NativeAdViewController alloc] initWithSlotId:@"697c1c4fa56addbb35024c27"];
        }]
    ];
    
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[AdListCell class] forCellReuseIdentifier:@"AdListCell"];
    
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdListCell" forIndexPath:indexPath];
    
    AdMenuItem *item = self.items[indexPath.row];
    [cell configureWithData:item];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AdMenuItem *selectedItem = self.items[indexPath.row];
    if (selectedItem.actionBlock) {
        UIViewController *destinationVC = selectedItem.actionBlock();
        if (destinationVC) {
            destinationVC.title = selectedItem.title;
            if (self.navigationController) {
                [self.navigationController pushViewController:destinationVC animated:YES];
            } else {
                [self presentViewController:destinationVC animated:YES completion:nil];
            }
        }
    }
}

@end
