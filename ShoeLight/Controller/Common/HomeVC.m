//
//  HomeVC.m
//  ShoeLight
//
//  Created by even on 16/2/13.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "HomeVC.h"
#import "macro.h"
#import "AdView.h"
#import "TabBarVC.h"
#import "Run.h"

@interface HomeVC ()
@property (strong, nonatomic) NSMutableArray *adArray;
@property (strong, nonatomic) AdView *adView;
@property (weak, nonatomic) IBOutlet UIButton *runModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *musicModeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImgView;
@property (weak, nonatomic) IBOutlet UIImageView *chargeImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsTopSpaceCons;
@property (weak, nonatomic) IBOutlet UIImageView *leftBatteryImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftChargeImgView;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //本地图片加载方法
    NSArray *imagesURL = @[
                           @"广告1@3x.png",
                           @"广告2@3x.png",
                           @"广告3@3x.png",
                           @"广告4@3x.png"
                           ];
    
    //如果你的这个广告视图是添加到导航控制器子控制器的View上,请添加此句,否则可忽略此句
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 200 / 320) localImageLinkURL:imagesURL  pageControlShowStyle:UIPageControlShowStyleRight];
    [self.view addSubview:self.adView];
    
    [self configureRightBarBtnItem];
    [self updateLanguage];
    self.batteryImgView.hidden = YES;
    self.chargeImgView.hidden = YES;
    
    self.leftBatteryImgView.hidden = YES;
    self.leftChargeImgView.hidden = YES;
    self.view.backgroundColor = kGlbBgColor;
    
    if (kScreenHeight == 480) {
        self.btnsTopSpaceCons.constant -= 70;
    }
    
//    [kNotificationCenter addObserver:self selector:@selector(sendGetBatteryDataCmd) name:@"BLEDidDiscoverCharacteristic" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(leftBLEDisconnected) name:@"LeftBLEDisconnected" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(rightBLEDisconnected) name:@"RightBLEDisconnected" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 如果没有连接蓝牙，连接蓝牙
//    [[BLE sharedInstance] removeDiscoveredPeripheralsExceptConnected];
//    [[BLE sharedInstance] startScan];
    

    kMyProfileTool.currentMode = ModeIdle;
    
    // 取出当前引导页面版本，以及播放过的引导页面版本
    NSString *guideVersionKey = @"CFBundleGuideVersionString";
    NSString *currentGuideVersion = [NSBundle mainBundle].infoDictionary[guideVersionKey];
    NSString *playedGuideVersion = [kUserDefaults objectForKey:guideVersionKey];
    
    // 播放的引导版本和plist中的当前引导界面版本一致，代表以前播放过主页面
    BOOL isFirstShow = ![playedGuideVersion isEqualToString:currentGuideVersion];
    if (isFirstShow) {
        // 代表以前没播放过主页面
        [kUserDefaults setObject:currentGuideVersion forKey:guideVersionKey];
        [kUserDefaults synchronize];
    } else {
        // 播放过就发熄灯指令
        [self performSelector:@selector(sendExitCmd) withObject:nil afterDelay:0.1];
    }
}

- (void)sendExitCmd {
    Byte bytes[] = {0xA5,0xFF};
    [kBLE writeBytesForPeripheral:bytes length:2];
}

- (void)leftBLEDisconnected {
    self.leftBatteryImgView.hidden = YES;
    self.leftChargeImgView.hidden = YES;
}

- (void)rightBLEDisconnected {
    self.batteryImgView.hidden = YES;
    self.chargeImgView.hidden = YES;
}

- (void)updateLanguage {
    if (kMyProfileTool.isEnglish) {
        [self.runModeBtn setTitle:@"Sports Mode" forState:UIControlStateNormal];
        [self.colorModeBtn setTitle:@"Color Mode" forState:UIControlStateNormal];
        [self.musicModeBtn setTitle:@"Music Mode" forState:UIControlStateNormal];
    } else {
        [self.runModeBtn setTitle:@"运动模式" forState:UIControlStateNormal];
        [self.colorModeBtn setTitle:@"炫彩模式" forState:UIControlStateNormal];
        [self.musicModeBtn setTitle:@"音乐模式" forState:UIControlStateNormal];
    }
    [self configureRightBarBtnItem];
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Harbor Intelligent Tech." : @"哈勃智能科技";
}

- (void)configureRightBarBtnItem {
    UIBarButtonItem *item;
    if (kMyProfileTool.isEnglish) {
        item = [[UIBarButtonItem alloc]initWithTitle:@"中文" style:UIBarButtonItemStylePlain target:self action:@selector(switchLanguage)];
    } else {
        item = [[UIBarButtonItem alloc]initWithTitle:@"English" style:UIBarButtonItemStylePlain target:self action:@selector(switchLanguage)];
    }
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)switchLanguage {
    kMyProfileTool.isEnglish = !kMyProfileTool.isEnglish;
    [self configureRightBarBtnItem];
    [self updateLanguage];
}

- (NSMutableArray *)adArray {
    if (_adArray == nil) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}


- (IBAction)modeBtnClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:@"TabBarVC" sender:sender];
    
    if (sender.tag == 0) {
        [self sendExitCmd];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    if ([segue.identifier isEqualToString:@"TabBarVC"]) {
        TabBarVC *tabBarVC = segue.destinationViewController;
        tabBarVC.selectedIndex = sender.tag;
    }
}


#pragma mark - BLE代理方法
- (void)discoveredBridge
{
    for (CBPeripheral *peripheral in [[BLE sharedInstance] discoveredDevices]) {
        if ([peripheral state] == CBPeripheralStateDisconnected && [peripheral.identifier.UUIDString isEqualToString:[kUserDefaults valueForKey:kLastConnectedBLEUUID]]) {
            [[BLE sharedInstance] connectPeripheral:peripheral];
        }
    }
}


- (void)didUpdateValueForLeftShoe
{
    NSArray *array = [[BLE sharedInstance] deviceCallBack];
    if (array.count != 0) {
        
        NSData *data = [array objectAtIndex:0];
        Byte *bytes = (Byte *)[data bytes];

        if (bytes[0] == 0xA9) {
            // 是否充电
            BOOL isCharging = bytes[1] & 0x80;
            self.leftChargeImgView.hidden = !isCharging;
            self.leftBatteryImgView.hidden = NO;
            // 0~100
            int battery = bytes[1] & 0x7F;
            if (battery >= 0 && battery <45) {
                self.leftBatteryImgView.image = [UIImage imageNamed:@"battery1"];
            } else if (battery >= 45 && battery <90) {
                self.leftBatteryImgView.image = [UIImage imageNamed:@"battery2"];
            } else if (battery >= 90 ) {
                self.leftBatteryImgView.image = [UIImage imageNamed:@"battery3"];
            }
            
        } else if (bytes[0] == 0xAA) {
            // 回执
            if (bytes[1] == 0xA8) {
                // 设备信息
                int version = bytes[2];
                int highVersion = version & 0x10;
                int lowVersion = version & 0x01;
                kMyProfileTool.deviceVersion = [NSString stringWithFormat:@"%@.%@",@(highVersion),@(lowVersion)];
            }
        }
    }
}

- (void)didUpdateValueForRightShoe
{
    NSArray *array = [[BLE sharedInstance] deviceCallBack];
    if (array.count != 0) {
        
        NSData *data = [array objectAtIndex:0];
        Byte *bytes = (Byte *)[data bytes];
        
        if (bytes[0] == 0xA9) {
            // 是否充电
            BOOL isCharging = bytes[1] & 0x80;
            self.chargeImgView.hidden = !isCharging;
            self.batteryImgView.hidden = NO;
            // 0~100
            int battery = bytes[1] & 0x7F;
            if (battery >= 0 && battery <45) {
                self.batteryImgView.image = [UIImage imageNamed:@"battery1"];
            } else if (battery >= 45 && battery <90) {
                self.batteryImgView.image = [UIImage imageNamed:@"battery2"];
            } else if (battery >= 90 ) {
                self.batteryImgView.image = [UIImage imageNamed:@"battery3"];
            }
            
        }  else if (bytes[0] == 0xA2) {
            // 步数
            int a = bytes[1];
            int b = bytes[2];
            int c = bytes[3];
            NSInteger step = (a << 16) + (b << 8) + c;

            int e = bytes[5];
            int f = bytes[6];
            int g = bytes[7];
            NSInteger distance = ((e << 16) + (f << 8) + g) * 0.01;
            
            // 闲时记录
            [Run runWithStartDate:[NSDate date]
                         stopDate:[NSDate date]
                             step:step
                         distance:distance
                       isIdleMode:YES];
        } else if (bytes[0] == 0xAA) {
            // 回执
            if (bytes[1] == 0xA8) {
                // 设备信息
                int version = bytes[2];
                int highVersion = version & 0x10;
                int lowVersion = version & 0x01;
                kMyProfileTool.deviceVersion = [NSString stringWithFormat:@"%@.%@",@(highVersion),@(lowVersion)];
            }
        }
    }
}



@end
