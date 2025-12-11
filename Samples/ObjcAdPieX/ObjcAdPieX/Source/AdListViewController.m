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
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Image" subtitle:@"전면 광고 - 이미지"],
        [AdMenuItem itemWithTitle:@"Interstitial Ad - Video" subtitle:@"전면 광고 - 비디오"],
        [AdMenuItem itemWithTitle:@"Rewarded Ad - Portrait" subtitle:@"리워드 광고 - 세로"],
        [AdMenuItem itemWithTitle:@"Rewarded Ad - Landscape" subtitle:@"리워드 광고 - 가로"],
        [AdMenuItem itemWithTitle:@"Native Ad" subtitle:@"네이티브 광고"]
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
    
    UIViewController * destinationVC = nil;
    switch (indexPath.row) {
        case 0: destinationVC = [[InterstitialAdViewController alloc] initWithSlotId:@"692919f192a14648b7f8bd94"]; break;
        case 1: destinationVC = [[InterstitialAdViewController alloc] initWithSlotId:@"69291a1592a14648b7f8bd96"]; break;
        case 2: destinationVC = [[RewardedAdViewController alloc] initWithSlotId:@"69291a4b92a14648b7f8bd9a"]; break;
        case 3: destinationVC = [[RewardedAdViewController alloc] initWithSlotId:@"69291a7692a14648b7f8bd9d"]; break;
        case 4: destinationVC = [[NativeAdViewController alloc] initWithSlotId:@"69291a2d92a14648b7f8bd98"]; break;
        default:
            return;
    }
    
    if (!destinationVC) {
        return;
    }
    
    AdMenuItem *selectedItem = self.items[indexPath.row];
    destinationVC.title = selectedItem.title;
    if (self.navigationController) {
        [self.navigationController pushViewController:destinationVC animated:YES];
    } else {
        [self presentViewController:destinationVC animated:YES completion:nil];
    }
}

@end
