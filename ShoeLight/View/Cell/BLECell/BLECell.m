//
//  BLECell.m
//  ShoeLight
//
//  Created by even on 16/2/25.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "BLECell.h"

@interface BLECell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end

@implementation BLECell



- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self routerEventWithName:kRouterEventNameBLECellSwitchValueChanged userInfo:self.peripheral];
}


- (void)setPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    
    self.nameLbl.text = peripheral.name;
//    
//    // 蓝牙是否开关
//    BOOL isBLEOn = NO;
//    for (CBPeripheral *aPeripheral in [[BabyBluetooth shareBabyBluetooth] findConnectedPeripherals]) {
//        if ([aPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
//            isBLEOn = YES;
//        }
//    }
    
    if (peripheral.state == CBPeripheralStateConnected) {
        self.switcher.on = YES;
    } else {
        self.switcher.on = NO;
    }
}

@end
