//
//  Texts.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/14/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "Texts.h"

@implementation Texts

+ (NSString*)nestConnectButtonTitle {
    return NSLocalizedString(@"NestConnectButtonTitle", nil);
}

+ (NSString*)welcome {
    return NSLocalizedString(@"welcome", nil);
}

+ (NSString*)loading {
    return NSLocalizedString(@"loading", nil);
}

+ (NSString*)connectWithNest {
    return NSLocalizedString(@"ConnectWithNest", nil);
}

+ (NSString*)thermostats {
    return NSLocalizedString(@"Thermostats", nil);
}

+ (NSString*)devices {
    return NSLocalizedString(@"Devices", nil);
}

+ (NSString*)noThermostatsMessage {
    return NSLocalizedString(@"NoThermostatsMessage", nil);
}

+ (NSString*)currentTemperature {
    return NSLocalizedString(@"CurrentTemperature", nil);
}

+ (NSString*)targetTemperature {
    return NSLocalizedString(@"TargetTemperature", nil);
}

@end
