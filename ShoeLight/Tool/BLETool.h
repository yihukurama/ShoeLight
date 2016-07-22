//
//  BLETool.h
//  ShoeLight
//
//  Created by even on 16/2/25.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <BabyBluetooth.h>

typedef enum : NSUInteger {
    ShoeTypeLeft,
    ShoeTypeRight,
} ShoeType;

@interface BLETool : NSObject
single_interface(BLETool)

@property (strong, nonatomic) CBPeripheral *peripheral0;
@property (strong, nonatomic) CBPeripheral *peripheral1;
@property (strong, nonatomic) CBCharacteristic *characteristic0;
@property (strong, nonatomic) CBCharacteristic *characteristic1;

- (void)writeToShoe:(ShoeType)shoeType bytes:(const void *)bytes length:(int)length;

@end
