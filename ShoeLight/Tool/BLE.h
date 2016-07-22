//
//  BLE.h
//  RemoteControl
//
//  Created by wukong on 15-3-24.
//  Copyright (c) 2015年 YKWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLEDelegate <NSObject>
@optional
- (void)CBPowerIsOff;
- (void)CBPoweredOn;
- (void)discoveredBridge;
- (void)didConnectBridge :(CBPeripheral *) bridge;
- (void)didUpdateValueForLeftShoe;
- (void)didUpdateValueForRightShoe;
@end

@interface BLE : NSObject

+ (id)sharedInstance;
- (void)connectPeripheral:(CBPeripheral *) peripheral;
- (void)disconnectPeripheral:(CBPeripheral *) peripheral;
- (void)removeDiscoveredPeripheralsExceptConnected;
- (void)startScan;
- (void)stopBLEScan;
- (void)writeValueForPeripheral:(NSData *)data;
// 连接蓝牙如果应该连接的蓝牙被断开了
- (void)connectShoesIfNeeded;

- (BOOL)isConnectedRightShoe;
- (BOOL)isConnectedLeftShoe;
- (BOOL)isConnectedBothShoes;
- (void)showConnectShoeIfNeeded;

/**
 *  发送不包含SOP以及CheckSum的纯数据给蓝牙
 *
 *  @param bytes  Cmd+Data
 *  @param length Cmd+Data的长度
 */
- (void)writeBytesForPeripheral:(const void *)bytes length:(int)length;

@property (nonatomic, strong) NSMutableArray *discoveredDevices;
@property (nonatomic, strong) NSMutableArray *deviceCallBack;

@property (nonatomic, assign) id<BLEDelegate>bleDelegate;

@end
