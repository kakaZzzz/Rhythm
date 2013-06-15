//
//  BTBandCentral.m
//  SmartBat
//
//  Created by kaka' on 13-6-15.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBandCentral.h"

@implementation BTBandCentral

-(id)init{
    self = [super init];
    
    if (self) {
        self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [[OALSimpleAudio sharedInstance] preloadEffect:@"tick.aif"];
    }
    
    return self;
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            //设置nil查找任何设备
            [central scanForPeripheralsWithServices:nil options:nil];
            
            NSLog(@"scan ForPeripherals");
            
            break;
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"Discover Peripheral: %@", peripheral);
    
    //找到了就停止扫描
    [central stopScan];
    
    //付给私有变量，不然就释放了
    self.p = peripheral;
    [central connectPeripheral:peripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"Connect Peripheral: %@", peripheral);
    
    //代理peripheral
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"DiscoverServices error: %@", error.localizedDescription);
    }
    
    NSLog(@"Discover Services: %@", peripheral.services);
    
    for (CBService *s in peripheral.services) {
        
        NSLog(@"%@", s.UUID);
        
        if ([s.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            NSLog(@"find target");
            
            [peripheral discoverCharacteristics:nil forService:s];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"DiscoverCharacteristics error: %@", error.localizedDescription);
    }
    
    NSLog(@"Discover Characteristics %@", service.characteristics);
    
    for (CBCharacteristic* c in service.characteristics) {
        NSLog(@"find characteristic %@", c);
        
        self.c = c;
        [peripheral setNotifyValue:YES forCharacteristic:c];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"UpdateNotificationStateForCharacteristic erroe:%@", error.localizedDescription);
    }
    
    if (characteristic.isNotifying) {
        
        NSLog(@"Notification began on %@", characteristic);
        
        [peripheral readValueForCharacteristic:characteristic];

    } else{
        NSLog(@"Notification stop %@", characteristic);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"UpdateValueForCharacteristic error: %@", error.localizedDescription);
    }
    
    [[OALSimpleAudio sharedInstance] playEffect:@"tick.aif"];
    NSLog(@"the value: %@", characteristic.value);
}

-(void)write{
    _i++;
    
    [_p writeValue:[NSData dataWithBytes:&_i length:sizeof(&_i)] forCharacteristic:_c type:CBCharacteristicWriteWithResponse];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"tick.aif"];
}

-(void)read{
    [_p readValueForCharacteristic:_c];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"tick.aif"];
}

@end