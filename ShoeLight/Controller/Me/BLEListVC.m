//
//  BLEListVC.m
//  RunLight
//
//  Created by even on 16/1/21.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "BLEListVC.h"
#import "macro.h"
#import "UIView+Frame.h"
#import "BLECell.h"
#import "BLE.h"

@interface BLEListVC () <BLEDelegate>
@property (strong, nonatomic) NSMutableArray *findPeripherals;

@end

@implementation BLEListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    [self updateLanguage];

    [kBLE setBleDelegate:self];
    [kBLE removeDiscoveredPeripheralsExceptConnected];
    [kBLE startScan];
    
    if (self.isGuide) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:(kMyProfileTool.isEnglish ? @"Save" : @"保存") style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    }
    

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打印蓝牙" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.tabBarController) {
        UINavigationController *navi = self.navigationController.tabBarController.viewControllers[0];
        [kBLE setBleDelegate:navi.viewControllers[0]];
    }
}

- (void)done {
    [kAppDelegate showStoryboardWithName:@"Main"];
}

- (void)test {
    NSLog(@"%@",[kBLE discoveredDevices]);
    Byte bytes[] = {0xA8};
    [kBLE writeBytesForPeripheral:bytes length:1];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)updateLanguage {
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Bluetooth Settings" : @"蓝牙设置";
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(CBPeripheral *)userInfo {
    
    if ([eventName isEqualToString:kRouterEventNameBLECellSwitchValueChanged]) {
        
        if(userInfo.state == CBPeripheralStateConnected) {
            // 断开链接
            [[BLE sharedInstance] disconnectPeripheral:userInfo];
            [self.tableView reloadData];
            
            
            // 把断开的左右脚的蓝牙UUID删除
            if ([userInfo.name hasPrefix:kLeftShoeNamePrefix]) {
                [kUserDefaults setValue:nil forKey:kLastConnectedLeftShoeUUIDKey];
                [kUserDefaults synchronize];
            } else if ([userInfo.name hasPrefix:kRightShoeNamePrefix]) {
                [kUserDefaults setValue:nil forKey:kLastConnectedRightShoeUUIDKey];
                [kUserDefaults synchronize];
                
                kMyProfileTool.deviceVersion = nil;
            }
            
        } else if(userInfo.state == CBPeripheralStateDisconnected) {
            // 连接蓝牙
            
            // 判断是否有连接上的，或者正在连接的左右蓝牙
            BOOL hasConnectedLeftShoe = NO;
            BOOL hasConnectedRightShoe = NO;
            for (CBPeripheral *per in [kBLE discoveredDevices]) {
                if (per.state == CBPeripheralStateConnected || per.state == CBPeripheralStateConnecting) {
                    
                    if ([per.name hasPrefix:kLeftShoeNamePrefix]) {
                        hasConnectedLeftShoe = YES;
                    } else if ([per.name hasPrefix:kRightShoeNamePrefix]) {
                        hasConnectedRightShoe = YES;
                    }
                }
            }
            
            BOOL isLeftShoe = [userInfo.name hasPrefix:kLeftShoeNamePrefix];
            BOOL isRightShoe = [userInfo.name hasPrefix:kRightShoeNamePrefix];
            
#warning 中文
            if (isLeftShoe && hasConnectedLeftShoe) {
                [kHudTool showHudOneSecondWithText:[LocalTool oneLeftShoeMost]];
            } else if (isRightShoe && hasConnectedRightShoe) {
                [kHudTool showHudOneSecondWithText:[LocalTool oneRightShoeMost]];
            } else {
                [[BLE sharedInstance] connectPeripheral:userInfo];
            }
            [self.tableView reloadData];
        }
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    MyLog(@"num%@",@([kBLE discoveredDevices].count));
    return [[[BLE sharedInstance] discoveredDevices] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLECell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.peripheral = [[BLE sharedInstance] discoveredDevices][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = kGetColorFromHex(0x999999, 1);
    label.text = kMyProfileTool.isEnglish ? @"Connect to device" : @"  可连接设备";
    [label sizeToFit];
    label.height = 20;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = kGetColorFromHex(0x999999, 1);
    label.text = kMyProfileTool.isEnglish ? @"Two devices with different names can be connected at most" : @"  现在你最多可以同时连接两个不同名字的设备";
    [label sizeToFit];
    label.height = 20;
    return label;
}


#pragma mark - BLE代理方法
- (void)discoveredBridge
{
    [self.tableView reloadData];
}

- (void)didConnectBridge:(CBPeripheral *)bridge
{
    [self.tableView reloadData];
}
@end
