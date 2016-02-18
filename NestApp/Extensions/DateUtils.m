//
//  DateUtils.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/16/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString*)mediumDateFormatFromUTC:(NSString*)utcDate {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *date = [formatter dateFromString:utcDate];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:date];
}

@end
