//
//  ZHJDevice.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJDevice.h"
#import "ZHJMarco.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <Security/Security.h>

@implementation ZHJKeyChainManager

+ (NSMutableDictionary *)getSeachDictionary:(NSString *)identifier {
    NSMutableDictionary *seachDictionary = [NSMutableDictionary dictionary];
    [seachDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [seachDictionary setObject:identifier forKey:(id)kSecAttrService];
    [seachDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    [seachDictionary setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    return seachDictionary;
}

+ (void)save:(NSString *)identifier data:(id)data {
    NSMutableDictionary *seachDictionary = [self getSeachDictionary:identifier];
    SecItemDelete((CFDictionaryRef)seachDictionary);
    [seachDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)seachDictionary, NULL);
}

+ (id)load:(NSString *)identifier {
    id result = nil;
    NSMutableDictionary *seachDictionary = [self getSeachDictionary:identifier];
    [seachDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [seachDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)seachDictionary, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }@catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", identifier, exception);
        }@finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}

+ (void)deleteKeyData:(NSString *)identifier {
    NSMutableDictionary *seachDictionary = [self getSeachDictionary:identifier];
    SecItemDelete((CFDictionaryRef)seachDictionary);
}

@end

#define k_ZHJDevice_CELLULAR    @"pdp_ip0"
#define k_ZHJDevice_WIFI        @"en0"
#define k_ZHJDevice_IPv4        @"ipv4"
#define k_ZHJDevice_IPv6        @"ipv6"

NSString *const k_ZHJDevice_UUIDForDeviceKey = @"k_ZHJDevice_UUIDForDeviceKey";

@interface ZHJDevice ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *network;
@end

@implementation ZHJDevice

static ZHJDevice *_device = nil;

#pragma mark - Initialization
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _device = [super allocWithZone:NULL];
        [_device locate];
    });
    return _device;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _device = [[self alloc] init];
    });
    return _device;
}

- (id)copyWithZone:(NSZone *)zone {
    return _device;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _device;
}

- (NSString *)IPv4 {
    NSArray *searchArray = @[k_ZHJDevice_WIFI @"/" k_ZHJDevice_IPv4, k_ZHJDevice_WIFI @"/" k_ZHJDevice_IPv6, k_ZHJDevice_CELLULAR @"/" k_ZHJDevice_IPv4, k_ZHJDevice_CELLULAR @"/" k_ZHJDevice_IPv6 ];
    NSDictionary *addresses = [self IP];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if(address) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}

- (NSString *)IPv6 {
    NSArray *searchArray = @[k_ZHJDevice_WIFI @"/" k_ZHJDevice_IPv6, k_ZHJDevice_WIFI @"/" k_ZHJDevice_IPv4, k_ZHJDevice_CELLULAR @"/" k_ZHJDevice_IPv6, k_ZHJDevice_CELLULAR @"/" k_ZHJDevice_IPv4 ] ;
    NSDictionary *addresses = [self IP];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if(address) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)IP {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = k_ZHJDevice_IPv4;
                    }
                }else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = k_ZHJDevice_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

- (NSString *)brand {
    return [[UIDevice currentDevice] localizedModel];
}

- (NSString *)model {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

- (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)resolution {
    UIScreen *screen = [UIScreen mainScreen];
    return [NSString stringWithFormat:@"%d*%d", (int)(screen.bounds.size.width*screen.scale), (int)(screen.bounds.size.height*screen.scale)];
}

- (void)locate{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1.0;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    CLLocation *currentLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        __strong __typeof(self) self = weakSelf;
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.placemark = placemark;
        }else if (error == nil && [array count] == 0) {
            NSLog(@"无定位数据");
        }else if (error != nil) {
            NSLog(@"反向地理编码失败：%@", error.localizedDescription);
        }
    }];
    
    // 停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败：%@", error.localizedDescription);
}

- (NSString *)countryCode {
    return [self.placemark.addressDictionary objectForKey:@"CountryCode"]?:@"";
}

- (NSString *)country {
    return [self.placemark.addressDictionary objectForKey:@"Country"]?:@"";
}

- (NSString *)state {
    return [self.placemark.addressDictionary objectForKey:@"State"]?:@"";
}

- (NSString *)city {
    return [self.placemark.addressDictionary objectForKey:@"City"]?:@"";
}

- (NSString *)subLocality {
    return [self.placemark.addressDictionary objectForKey:@"SubLocality"]?:@"";
}

- (NSString *)street {
    return [self.placemark.addressDictionary objectForKey:@"Street"]?:@"";
}

- (NSString *)thoroughfare {
    return [self.placemark.addressDictionary objectForKey:@"Thoroughfare"]?:@"";
}

- (NSString *)name {
    return [self.placemark.addressDictionary objectForKey:@"Name"]?:@"";
}

- (NSString *)formattedAddressLines {
    NSArray *formattedAddressLines = [self.placemark.addressDictionary objectForKey:@"FormattedAddressLines"]?:@[@""];
    return [formattedAddressLines objectAtIndex:0];
}

- (NSString *)longitude {
    return [NSString stringWithFormat:@"%.f", self.placemark.location.coordinate.longitude];
}

- (NSString *)latitude {
    return [NSString stringWithFormat:@"%.f", self.placemark.location.coordinate.latitude];
}

- (NSString *)UUID {
    //    return [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    _UUID = (NSString *)[ZHJKeyChainManager load:bundleID];
    if ([_UUID isEqualToString:@""] || !_UUID) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        _UUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault, uuidRef));
        [ZHJKeyChainManager save:bundleID data:_UUID];
    }
    return _UUID;
}

- (NSString *)getNetworkType {
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = [app valueForKeyPath:@"statusBar"];
    NSString *network = @"";
    
    if (ZHJ_IS_IPHONEX) {
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                network = @"WIFI";
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                network = [subview valueForKeyPath:@"originalText"];
            }
        }
    }else {
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0: network = @"NONE"; break;
                    case 1: network = @"2G"; break;
                    case 2: network = @"3G"; break;
                    case 3: network = @"4G"; break;
                    case 5: network = @"WIFI"; break;
                    default: break;
                }
            }
        }
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

- (NSString *)networkType {
    return [self getNetworkType];
}

- (NSString *)carrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    return [carrier carrierName];
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (NSString *)wifiSSID {
    return (NSString *)[self fetchSSIDInfo][@"SSID"];
}

- (NSString *)wifiBSSID {
    return (NSString *)[self fetchSSIDInfo][@"BSSID"];
}

- (int)wifiSignalStrength {
    int signalStrength = 0;
    if ([[self getNetworkType]isEqualToString:@"WIFI"]) {
        UIApplication *app = [UIApplication sharedApplication];
        id statusBar = [app valueForKey:@"statusBar"];
        if (ZHJ_IS_IPHONEX) {
            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
            NSArray *subviews = [[foregroundView subviews][2] subviews];
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                }
            }
        }else {
            UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
            NSArray *subviews = [foregroundView subviews];
            NSString *dataNetworkItemView = nil;
            for (id subview in subviews) {
                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    dataNetworkItemView = subview;
                    break;
                }
            }
            signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
        }
    }
    return signalStrength;
}

@end
