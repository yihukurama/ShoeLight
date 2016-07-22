//
//  BLETool.m
//  ShoeLight
//
//  Created by even on 16/2/25.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "BLETool.h"

@interface BLETool ()

@end

@implementation BLETool
single_implementation(BLETool)


- (void)writeToShoe:(ShoeType)shoeType bytes:(const void *)bytes length:(int)length;
{
    Byte *dataBytes = (Byte *)bytes;
    
    Byte dataLength = length;
    int totalLengh = dataLength + 4;
    
    // 动态分配将要发送的整个数组
    Byte *sendBytes;
    sendBytes = (Byte *) malloc(totalLengh * sizeof(Byte));
    
    for (int i = 0; i < totalLengh; i ++) {
        if (i == 0) {
            sendBytes[i] = 0x55;
        }
        else if (i == 1) {
            sendBytes[i] = 0xaa;
        }
        else if (i == 2) {
            // 不包含cmd的长度
            sendBytes[i] = dataLength - 2;
        }
        else if (i == totalLengh - 1) {
            // 计算checkSum
            Byte checkSum = 0;
            for (int j = 2; j < totalLengh - 1; j ++) {
                checkSum -= sendBytes[j];
            }
            sendBytes[i] = checkSum;
        }
        else {
            sendBytes[i] = dataBytes[i - 3];
        }
    }
    
    NSData *data = [[NSData alloc] initWithBytes:sendBytes length:totalLengh];
    [self writeValueForPeripheral:data];
    free(sendBytes);
}

- (void)writeValueForPeripheral:(NSData *)data
{
    NSLog(@"\n\nsended_data:%@",data);
    [self.peripheral0 writeValue:data forCharacteristic:self.characteristic0 type:CBCharacteristicWriteWithResponse];

}

@end
