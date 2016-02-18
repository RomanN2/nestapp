//
//  NestCameraManager.h
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Camera;

@protocol NestCameraManagerDelegate <NSObject>
- (void)cameraValuesChanged:(Camera *)camera;
@end

@interface NestCameraManager : NSObject

@property (nonatomic, strong) id <NestCameraManagerDelegate>delegate;
- (void)beginSubscriptionForCamera:(Camera *)camera;

@end
