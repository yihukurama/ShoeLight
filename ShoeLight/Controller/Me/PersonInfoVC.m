//
//  PersonInfoVC.m
//  ShoeLight
//
//  Created by even on 16/2/13.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "PersonInfoVC.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "macro.h"
#import "BLEListVC.h"

#define kMaxWeight 300
#define kMaxHeight 255
#define kMaxAge    80


@interface PersonInfoVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ageFld;
@property (weak, nonatomic) IBOutlet UITextField *heightFld;
@property (weak, nonatomic) IBOutlet UITextField *weightFld;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;


@property (weak, nonatomic) IBOutlet UILabel *genderTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *hightTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *weightTextLbl;

@end

@implementation PersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    [self.tableView setHeaderHeight:0.1];
    
    self.ageFld.text = [NSString stringWithFormat:@"%@",@(kMyProfileTool.age)];
    self.heightFld.text = [NSString stringWithFormat:@"%@",@(kMyProfileTool.height)];
    self.weightFld.text = [NSString stringWithFormat:@"%@",@(kMyProfileTool.weight)];
    
    if (kMyProfileTool.isEnglish) {
        self.genderLbl.text = [kMyProfileTool.gender isEqualToString:@"male"] ? @"Male" : @"Female";
    } else {
        self.genderLbl.text = [kMyProfileTool.gender isEqualToString:@"male"] ? @"男" : @"女";
    }
    
    [self updateLanguage];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:(kMyProfileTool.isEnglish ? @"Save" : @"保存") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.ageFld.delegate = self;
    self.heightFld.delegate = self;
    self.weightFld.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];


}

- (void)updateLanguage {
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Personal Information" : @"个人信息";
    self.genderTextLbl.text = kMyProfileTool.isEnglish ? @"Sex" : @"性别";
    self.ageTextLbl.text = kMyProfileTool.isEnglish ? @"Age" : @"年龄";
    self.hightTextLbl.text = kMyProfileTool.isEnglish ? @"Height(cm)" : @"身高(cm)";
    self.weightTextLbl.text = kMyProfileTool.isEnglish ? @"Weight(kg)" : @"体重(kg)";
}

- (void)save {
    
#warning 中文
    NSString *hudStr;
    if (self.ageFld.text.intValue == 0) {
        hudStr = kMyProfileTool.isEnglish ? @"请输入年龄" : @"请输入年龄";
        [kHudTool showHudOneSecondWithText:hudStr];
        return;
    }
    
    if (self.weightFld.text.intValue == 0) {
        hudStr = kMyProfileTool.isEnglish ? @"请输入体重" : @"请输入体重";
        [kHudTool showHudOneSecondWithText:hudStr];
        return;
    }
    
    if (self.heightFld.text.intValue == 0) {
        hudStr = kMyProfileTool.isEnglish ? @"请输入身高" : @"请输入身高";
        [kHudTool showHudOneSecondWithText:hudStr];
        return;
    }
    
    kMyProfileTool.age = [self.ageFld.text integerValue];
    kMyProfileTool.height = [self.heightFld.text integerValue];
    kMyProfileTool.weight = [self.weightFld.text integerValue];
    kMyProfileTool.gender = [self.genderLbl.text isEqualToString:@"女"] ? @"female" : @"male";
    
    
    if (self.isGuide) {
        BLEListVC *list = [kMainStoryboard instantiateViewControllerWithIdentifier:@"BLEListVC"];
        list.isGuide = YES;
        [self.navigationController pushViewController:list animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        [self.view endEditing:YES];
        NSArray *btns = kMyProfileTool.isEnglish ? @[@"Male",@"Female"] : @[@"男",@"女"];
        WEAKSELF
       [UIActionSheet actionSheetWithTitle:nil message:nil buttons:btns showInView:self.view onDismiss:^(NSInteger buttonIndex) {
           weakSelf.genderLbl.text = btns[buttonIndex];
        } onCancel:nil];

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (IBAction)fldEditingDidBegin:(UITextField *)sender {
    if ([sender.text integerValue] == 0) {
        sender.text = @"";
    }
}



- (IBAction)ageFldEditingDidChanged:(UITextField *)sender {
    NSInteger input = [sender.text integerValue];
    if (input <= 0) {
        sender.text = @"";
    }
    
//    else if (input > kMaxAge) {
//        input = kMaxAge;
//        sender.text = [NSString stringWithFormat:@"%@",@(input)];
//    }
    
    else {
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
}

- (IBAction)heightFldEditingDidChanged:(UITextField *)sender {
    NSInteger input = [sender.text integerValue];
    if (input <= 0) {
        sender.text = @"";
    }
//    else if (input > kMaxHeight) {
//        input = kMaxHeight;
//        sender.text = [NSString stringWithFormat:@"%@",@(input)];
//    }
    else {
        
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
}

- (IBAction)weightFldEditingDidChanged:(UITextField *)sender {
    NSInteger input = [sender.text integerValue];
    if (input <= 0) {
        sender.text = @"";
    }
//    else if (input > kMaxWeight) {
//        input = kMaxWeight;
//        sender.text = [NSString stringWithFormat:@"%@",@(input)];
//    }
    else {
        
        sender.text = [NSString stringWithFormat:@"%@",@([sender.text integerValue])];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *textM = [NSMutableString stringWithString:textField.text];
    [textM replaceCharactersInRange:range withString:string];
    
    NSInteger input = [textM integerValue];
    if (textField == self.ageFld && input > kMaxAge) {
        return  NO;
    } else if (textField == self.weightFld && input > kMaxWeight) {
        return  NO;
    } else if (textField == self.heightFld && input > kMaxHeight) {
        return  NO;
    }
    
    return YES;
}


@end
