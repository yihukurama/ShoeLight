//
//  AboutUsVC.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#define kPhone @"0769-81181829"
#define kWebsite @"http://www.har-bor.com"

#import "AboutUsVC.h"
#import "macro.h"
#import "WebVC.h"
#import "UITableView+Add.h"
#import "ImageVC.h"

@interface AboutUsVC ()

@property (weak, nonatomic) IBOutlet UILabel *modelLbl;
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *websiteLbl;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLbl;


@property (weak, nonatomic) IBOutlet UILabel *gradeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeModelTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeVersionTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *websiteTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyProfileTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamProfileTextLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    self.phoneLbl.text = kPhone;
    self.websiteLbl.text = kWebsite;
    NSString *string = kMyProfileTool.isEnglish ? @"Harbor Intelligent Tech.":@"哈勃智能科技";
    self.appVersionLbl.text = [NSString stringWithFormat:@"%@ %@",string,[[NSBundle mainBundle]infoDictionary][kBundleVersionKey]];
    self.versionLbl.text = kMyProfileTool.deviceVersion;
    self.iconImgView.layer.cornerRadius = 15;
    self.iconImgView.layer.masksToBounds = YES;
    [self updateLanguage];
}


- (void)updateLanguage {
    self.gradeTextLbl.text = kMyProfileTool.isEnglish ? @"Dear, please give a favourable comment!" : @"亲，给个好评呗！";
    self.shoeModelTextLbl.text = kMyProfileTool.isEnglish ? @"flashing shoes model" : @"闪光鞋型号";
    self.shoeVersionTextLbl.text = kMyProfileTool.isEnglish ? @"flashing shoes version" : @"闪光鞋版本";
    self.phoneTextLbl.text = kMyProfileTool.isEnglish ? @"Telephone" : @"联系电话";
    self.websiteTextLbl.text = kMyProfileTool.isEnglish ? @"Website" : @"网址链接";
    self.companyProfileTextLbl.text = kMyProfileTool.isEnglish ? @"Company Profile" : @"公司简介";
    self.teamProfileTextLbl.text = kMyProfileTool.isEnglish ? @"Team Development" : @"团队开发";
    self.navigationItem.title = kMyProfileTool.isEnglish ?  @"About Us" : @"关于我们";
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
        case 0: {
            // 评价
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1:
            break;
        case 2:
            
            break;
        case 3:
            // 打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"076981181829"]]];
            break;
        case 4: {
            // 网址
            WebVC *webVC = [kMainStoryboard instantiateViewControllerWithIdentifier:@"WebVC"];
            [webVC configureWithUrl:kWebsite title:@"公司网址"];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 5: {
            // 公司简介
            ImageVC *vc = [[ImageVC alloc]init];
            vc.englishImageName = @"company_info_english";
            vc.chineseImageName = @"company_info_chinese";
            vc.navigationItem.title = kMyProfileTool.isEnglish ? @"Company Profile" : @"公司简介";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            // 团队开发
            ImageVC *vc = [[ImageVC alloc]init];
            vc.englishImageName = @"team_info_english";
            vc.chineseImageName = @"team_info_chinese";
            vc.navigationItem.title = kMyProfileTool.isEnglish ? @"Team Development" : @"团队开发";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
