//
//  BLE.m
//  RemoteControl
//
//  Created by wukong on 15-3-24.
//  Copyright (c) 2015年 YKWang. All rights reserved.
//

#import "BLE.h"
#import "macro.h"

@interface BLE ()<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *centralmanager;
//    CBCharacteristic *readCharacteristic;
    NSTimer *timer;
}

@property (strong, nonatomic) CBPeripheral *leftShoePeripheral;
@property (strong, nonatomic) CBPeripheral *rightShoePeripheral;
@property (strong, nonatomic) CBCharacteristic *leftShoeWriteCharacteristic;
@property (strong, nonatomic) CBCharacteristic *rightShoeWriteCharacteristic;
@property (strong, nonatomic) CBCharacteristic *leftShoeReadCharacteristic;
@property (strong, nonatomic) CBCharacteristic *rightShoeReadCharacteristic;
@end

@implementation BLE
@synthesize discoveredDevices, deviceCallBack, bleDelegate;

+ (id)sharedInstance {
    static BLE	*this	= nil;
    
    if (!this)
        this = [[BLE alloc] init];
    
    return this;
}

- (id)init {
    self = [super init];
    if (self) {
        self.rightShoePeripheral = nil;
        self.leftShoePeripheral = nil;
        centralmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        discoveredDevices = [[NSMutableArray alloc] init];
        deviceCallBack = [[NSMutableArray alloc] init];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connectShoesIfNeeded) userInfo:nil repeats:YES];
    }
    return self;
}



- (BOOL)isConnectedRightShoe {
    return self.rightShoePeripheral != nil && self.rightShoeWriteCharacteristic != nil;
}

- (BOOL)isConnectedLeftShoe {
    return self.leftShoePeripheral != nil && self.leftShoeWriteCharacteristic != nil;
}

- (BOOL)isConnectedBothShoes {
    return [self isConnectedRightShoe] && [self isConnectedLeftShoe];
}

- (void)showConnectShoeIfNeeded {
    if (![self isConnectedLeftShoe] && ![self isConnectedRightShoe]) {
        [kHudTool showHudOneSecondWithText:[LocalTool shoesNeedToConnect]];
    } else if (![self isConnectedLeftShoe]) {
        [kHudTool showHudOneSecondWithText:[LocalTool leftShoeNeedToConnect]];
    } else if (![self isConnectedRightShoe]) {
        [kHudTool showHudOneSecondWithText:[LocalTool rightShoeNeedToConnect]];
    }
}


- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    if ([peripheral.name hasPrefix:kLeftShoeNamePrefix] && self.leftShoePeripheral && [self.leftShoePeripheral state] != CBPeripheralStateDisconnected) {
        [self disconnectPeripheral:self.leftShoePeripheral];
        self.leftShoePeripheral = nil;
    } else if ([peripheral.name hasPrefix:kRightShoeNamePrefix] && self.rightShoePeripheral && [self.rightShoePeripheral state] != CBPeripheralStateDisconnected) {
        [self disconnectPeripheral:self.rightShoePeripheral];
        self.rightShoePeripheral = nil;
    }
    
    if ([peripheral state] != CBPeripheralStateConnected) {
        [centralmanager connectPeripheral:peripheral options:nil];
    }
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral
{
    [centralmanager cancelPeripheralConnection:peripheral];
}

- (void)removeDiscoveredPeripheralsExceptConnected
{
    NSMutableArray *toDelete = [NSMutableArray array];
    for (CBPeripheral *aPeripheral in discoveredDevices) {
        if (aPeripheral != self.leftShoePeripheral && aPeripheral != self.rightShoePeripheral) {
            [toDelete addObject:aPeripheral];
        }
    }
    
    [discoveredDevices removeObjectsInArray:toDelete];
}

- (void)startScan
{
    @synchronized(self){
        if ([centralmanager state] == CBCentralManagerStatePoweredOn) {
            [centralmanager scanForPeripheralsWithServices:nil options:nil];
        }
    }
}

- (void)stopBLEScan
{
    @synchronized(self){
        [centralmanager stopScan];
    }
}

// 连接蓝牙如果应该连接的蓝牙被断开了
- (void)connectShoesIfNeeded {
    for (CBPeripheral *peripheral in self.discoveredDevices) {
        if (peripheral.state == CBPeripheralStateDisconnected &&
                   ([peripheral.identifier.UUIDString isEqualToString:kLastConnectedLeftShoeUUID] || [peripheral.identifier.UUIDString isEqualToString:kLastConnectedRightShoeUUID])) {
            [[BLE sharedInstance] connectPeripheral:peripheral];
        }
    }
    
//    MyLog(@"连接了蓝牙一次");
}

#pragma mark - CBCentralManager Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    switch ([centralmanager state]) {
        case CBCentralManagerStatePoweredOff:
            if (bleDelegate && [bleDelegate respondsToSelector:@selector(CBPowerIsOff)]) {
                [bleDelegate CBPowerIsOff];
            }
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStatePoweredOn:{
            if (bleDelegate && [bleDelegate respondsToSelector:@selector(CBPoweredOn)]) {
                [bleDelegate CBPoweredOn];
            }
            [centralmanager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnsupported:
            break;
            
        default:
            break;
    }
    previousState = [centralmanager state];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![discoveredDevices containsObject:peripheral] && ([peripheral.name hasPrefix:kLeftShoeNamePrefix] || [peripheral.name hasPrefix:kRightShoeNamePrefix])) {
        [discoveredDevices addObject:peripheral];
    }
    if (bleDelegate && [bleDelegate respondsToSelector:@selector(discoveredBridge)]) {
        [bleDelegate discoveredBridge];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    if ([peripheral.name hasPrefix:kLeftShoeNamePrefix]) {
        // 左鞋
        if (self.leftShoePeripheral && self.leftShoePeripheral != peripheral) {
            [self disconnectPeripheral:self.leftShoePeripheral];
            self.leftShoePeripheral = peripheral;
        }
        self.leftShoePeripheral = peripheral;
        [kUserDefaults setValue:peripheral.identifier.UUIDString forKey:kLastConnectedLeftShoeUUIDKey];
        [kUserDefaults synchronize];
        [kHudTool showHudOneSecondWithText:[LocalTool leftShoeConnected]];
 
    } else if ([peripheral.name hasPrefix:kRightShoeNamePrefix]) {
        // 右鞋
        if (self.rightShoePeripheral && self.rightShoePeripheral != peripheral) {
            [self disconnectPeripheral:self.rightShoePeripheral];
            self.rightShoePeripheral = peripheral;
        }
        self.rightShoePeripheral = peripheral;
        [kUserDefaults setValue:peripheral.identifier.UUIDString forKey:kLastConnectedRightShoeUUIDKey];
        [kUserDefaults synchronize];
        [kHudTool showHudOneSecondWithText:[LocalTool rightShoeConnected]];
        
    } else {
        // 非左右鞋则忽略
        return;
    }
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    if (bleDelegate && [bleDelegate respondsToSelector:@selector(discoveredBridge)]) {
        [bleDelegate discoveredBridge];
    }
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (peripheral == self.leftShoePeripheral) {
        [self.leftShoePeripheral setDelegate:nil];
        self.leftShoePeripheral = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftBLEDisconnected" object:nil];
        [kHudTool showHudOneSecondWithText:[LocalTool leftShoeDisconnected]];

    } else if(peripheral == self.rightShoePeripheral) {
        [self.rightShoePeripheral setDelegate:nil];
        self.rightShoePeripheral = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RightBLEDisconnected" object:nil];
        [kHudTool showHudOneSecondWithText:[LocalTool rightShoeDisconnected]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error == nil) {
        if (peripheral.state == CBPeripheralStateConnected) {
            for (CBService *service in peripheral.services) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error == nil) {
        [centralmanager stopScan];
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                if ([peripheral.name hasPrefix:kLeftShoeNamePrefix]) {
                    self.leftShoeReadCharacteristic = characteristic;
                } else if ([peripheral.name hasPrefix:kRightShoeNamePrefix]) {
                    self.rightShoeReadCharacteristic = characteristic;
                }
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//                [kNotificationCenter postNotificationName:@"BLEDidDiscoverCharacteristic" object:nil];

                
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]] ) {
                if ([peripheral.name hasPrefix:kLeftShoeNamePrefix]) {
                    self.leftShoeWriteCharacteristic = characteristic;
                } else if ([peripheral.name hasPrefix:kRightShoeNamePrefix]) {
                    self.rightShoeWriteCharacteristic = characteristic;
                }
                // 获取设备信息
                [self getDeviceInfo];
                [peripheral readValueForCharacteristic:characteristic];
//                [kNotificationCenter postNotificationName:@"BLEDidDiscoverCharacteristic" object:nil];

            }
        }
        
        if (bleDelegate && [bleDelegate respondsToSelector:@selector(didConnectBridge:)]) {
            [bleDelegate didConnectBridge:peripheral];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSData *recvData = characteristic.value;
    for (int i = 0; i < recvData.length; i++) {}
    [deviceCallBack removeAllObjects];
    
    if (characteristic == self.leftShoeReadCharacteristic) {
        NSLog(@"左读特征收：%@",recvData);
//        Byte *bytes = (Byte *)[recvData bytes];
//        if (bytes[1] == 0xA5) {
//            return;
//        }
        
        if([bleDelegate respondsToSelector:@selector(didUpdateValueForLeftShoe)]){
            [deviceCallBack addObject:recvData];
            [bleDelegate didUpdateValueForLeftShoe];
        }
        
    } else if (characteristic == self.rightShoeReadCharacteristic) {
        NSLog(@"右读特征收：%@",recvData);
        
        Byte *bytes = (Byte *)[recvData bytes];
        if (bytes[1] == 0xA5) {
            return;
        }

        
        if([bleDelegate isKindOfClass:[UIViewController class]]&&[bleDelegate respondsToSelector:@selector(didUpdateValueForRightShoe)]){
            [deviceCallBack addObject:recvData];
            [bleDelegate didUpdateValueForRightShoe];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
}

#pragma mark - Private
- (void)discoverRightShowServices {
    [self.rightShoePeripheral discoverServices:nil];
}

- (void)writeValueForPeripheral:(NSData *)data
{
    NSLog(@"\n\nsended_data:%@",data);
    BOOL hasConnectedLeftShoe = self.leftShoePeripheral != nil && self.leftShoeWriteCharacteristic != nil;
    BOOL hasConnectedRightShoe = self.rightShoePeripheral != nil && self.rightShoeWriteCharacteristic != nil;
    
    if (!self.rightShoePeripheral) {
//        MyLog(@"没有连接上右鞋");
    }
    
    if (!self.leftShoePeripheral) {
//        MyLog(@"没有连接上左鞋");
    }
    
    if (!hasConnectedLeftShoe && !hasConnectedRightShoe) {
//        NSLog(@"两只鞋均未连接上蓝牙");
        return;
    }
    
    if (self.leftShoeWriteCharacteristic) {
        [self.leftShoePeripheral writeValue:data forCharacteristic:self.leftShoeWriteCharacteristic type:CBCharacteristicWriteWithResponse];
    } else {
//        MyLog(@"左鞋特征值没有获取到");
    }
    
    if (self.rightShoeWriteCharacteristic) {
        [self.rightShoePeripheral writeValue:data forCharacteristic:self.rightShoeWriteCharacteristic type:CBCharacteristicWriteWithResponse];
    } else {
//        MyLog(@"右鞋特征值没有获取到");
        if(self.rightShoePeripheral)[self disconnectPeripheral:self.rightShoePeripheral];
        self.rightShoePeripheral = nil;
    }
    
    if (deviceCallBack.count > 0) {
        [deviceCallBack removeAllObjects];
    }
}


- (void)writeBytesForPeripheral:(const void *)bytes length:(int)length
{
    NSData *data = [[NSData alloc] initWithBytes:bytes length:length];
    [self writeValueForPeripheral:data];
}

// 发送请求命令获取设备信息
- (void)getDeviceInfo {
    Byte bytes[] = {0xA8};
    [self writeBytesForPeripheral:bytes length:1];
}

@end
