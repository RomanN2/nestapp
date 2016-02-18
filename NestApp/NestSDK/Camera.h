//
//  Camera.h
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Camera : NSObject

@property (nonatomic, strong) NSString *cameraId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastEventImageUrl;
@property (nonatomic, strong) NSString *lastEventDate;

@end
