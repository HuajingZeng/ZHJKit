//
//  ZHJDevice.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHJKeyChainManager : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end

@interface ZHJDevice : NSObject

+ (ZHJDevice *)sharedInstance;
- (NSString *)IPv4;//32位IP地址
- (NSString *)IPv6;//48位IP地址
- (NSString *)brand;//品牌
- (NSString *)model;//型号
- (NSString *)systemVersion;//系统版本
- (NSString *)resolution;//分辨率
- (NSString *)countryCode;//国家代号
- (NSString *)country;//国家
- (NSString *)state;//州、省、自治区、直辖市
- (NSString *)city;//城市
- (NSString *)subLocality;//区县
- (NSString *)street;//街道
- (NSString *)thoroughfare;//路
- (NSString *)name;//名称
- (NSString *)formattedAddressLines;//格式化地址
- (NSString *)longitude;//经度
- (NSString *)latitude;//纬度
- (NSString *)UUID;//唯一识别码
- (NSString *)networkType;//网络类型
- (NSString *)carrierName;//网络运营商
- (NSString *)wifiSSID;//Wifi的名字
- (NSString *)wifiBSSID;//Wifi的MAC地址
- (int)wifiSignalStrength;//Wifi的信号强度

@end
