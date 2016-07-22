//
//  BLECell.h
//  ShoeLight
//
//  Created by even on 16/2/25.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kRouterEventNameBLECellSwitchValueChanged @"kRouterEventNameBLECellSwitchValueChanged"

@interface BLECell : UITableViewCell

@property (strong, nonatomic) CBPeripheral *peripheral;

@end
