//
//  LightVC.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "LightVC.h"
#import "UIViewController+TabBarVCDismiss.h"
#import "macro.h"
#import "UIResponder+Router.h"
#import "LightTypeView.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface LightVC () 

@property (weak, nonatomic) UILabel *selectedLbl;
@property (weak, nonatomic) IBOutlet UILabel *lightTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *sevenColorLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentColorLbl;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *orangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *greenBtn;
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinkBtn;
@property (weak, nonatomic) IBOutlet UIButton *whiteBtn;
@property (weak, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet LightTypeView *lightTypeView;



@end

@implementation LightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDissmissBtnToLeftBarBtnItem];

    
    self.view.backgroundColor = kGlbBgColor;
    [self updateLanguage];
    
    WEAKSELF
    
#warning 中文
    self.lightTypeView.shouldValueChangeBlock =  ^(NSInteger index) {
//        if (kMyProfileTool.currentMode == ModeRun) {
//            [UIAlertView alertViewWithTitle:nil message:@"进入当前模式，其他模式将退出？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] onDismiss:^(NSInteger buttonIndex) {
//                // 关闭
//                weakSelf.lightTypeView.selectedIndex = index;
//                kMyProfileTool.currentMode = ModeMusic;
//                
//                [kNotificationCenter postNotificationName:kBeginLightModeNotification object:nil];
//                
//            } onCancel:nil];
//            return NO;
//        }
//        
//        else
            if (kMyProfileTool.currentMode == ModeMusic) {
            [UIAlertView alertViewWithTitle:nil message:[LocalTool toCurrentModeWillExitMode:ModeMusic] cancelButtonTitle:[LocalTool cancel] otherButtonTitles:@[[LocalTool close]] onDismiss:^(NSInteger buttonIndex) {
                // 关闭
                [kBLE showConnectShoeIfNeeded];
                
                weakSelf.lightTypeView.selectedIndex = index;
                kMyProfileTool.currentMode = ModeMusic;
                [weakSelf performSelector:@selector(sendCurrentCmd) withObject:nil afterDelay:0.1];
                [kNotificationCenter postNotificationName:kBeginLightModeNotification object:nil];

                
            } onCancel:nil];
            return NO;
        }
        
        else {
            return YES;
        }
    };
    
    self.lightTypeView.valueChangedBlock = ^(NSInteger index) {
        
        
        [kBLE showConnectShoeIfNeeded];
        [weakSelf sendCurrentCmd];
        [kNotificationCenter postNotificationName:kBeginLightModeNotification object:nil];

    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)sendCurrentCmd {
    
    NSInteger type;
    switch (self.lightTypeView.selectedIndex) {
        case 0:
            type = 0x10;
            break;
        case 1:
            type = 0x20;
            break;
        case 2:
            type = 0x30;
            break;
        case 3:
            type = 0x40;
            break;
        default:
            break;
    }
    NSInteger color = self.selectedBtn.tag;
    if (color == 0) {
        color = 1;
    }
    
    kMyProfileTool.currentMode = ModeLight;
    Byte bytes[] = {0xA5,type + color};
    [kBLE writeBytesForPeripheral:bytes length:2];
}


- (IBAction)colorBtnClicked:(UIButton *)btn {
    WEAKSELF
    [CommonTool excuteBlockInLightMode:^(){
        
        
        [kBLE showConnectShoeIfNeeded];
        
        weakSelf.selectedBtn = btn;
        [weakSelf updateSelectedColorLbl];
        [weakSelf sendCurrentCmd];
        [kNotificationCenter postNotificationName:kBeginLightModeNotification object:nil];
    }];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo {
    [self updateSelectedColorLbl];
}

- (void)updateLanguage {
    if(kMyProfileTool.isEnglish) {
        [self.redBtn setTitle:@"Red" forState:UIControlStateNormal];
        [self.orangeBtn setTitle:@"Orange" forState:UIControlStateNormal];
        [self.yellowBtn setTitle:@"Yellow" forState:UIControlStateNormal];
        [self.greenBtn setTitle:@"Green" forState:UIControlStateNormal];
        [self.blueBtn  setTitle:@"Blue" forState:UIControlStateNormal];
        [self.pinkBtn setTitle:@"Purple" forState:UIControlStateNormal];
        [self.whiteBtn setTitle:@"White" forState:UIControlStateNormal];
        self.lightTypeLbl.text = @"Flashing Type";
        self.sevenColorLbl.text = @"RGB color lights";
        
        self.navigationItem.title = @"Color Mode";
        [self updateSelectedColorLbl];
    } else {
        
    }
}

- (void)updateSelectedColorLbl {
    if (self.selectedBtn == self.redBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：浪漫红" : @"Current color:Red");
    } else if (self.selectedBtn == self.orangeBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：活泼橙" : @"Current color:Orange");
    } else if (self.selectedBtn == self.yellowBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：明亮黄" : @"Current color:Yellow");
    } else if (self.selectedBtn == self.greenBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：浪漫红" : @"Current color:Green");
    } else if (self.selectedBtn == self.blueBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：宁静蓝" : @"Current color:Blue");
    } else if (self.selectedBtn == self.pinkBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：优雅粉" : @"Current color:Pink");
    } else if (self.selectedBtn == self.whiteBtn) {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：纯洁白" : @"Current color:White");
    } else {
        self.currentColorLbl.text = (!kMyProfileTool.isEnglish ? @"当前颜色：浪漫红" : @"Current color:Red");
    }
}

@end
