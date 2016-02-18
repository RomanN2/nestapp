//
//  NestCameraManager.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "NestCameraManager.h"
#import "FirebaseManager.h"
#import "Camera.h"

#define CAMERA_NAME @"name"
#define LAST_CAMERA_EVENT @"last_event"
#define IMAGE_URL @"image_url"
#define END_TIME @"end_time"

@implementation NestCameraManager

- (void)beginSubscriptionForCamera:(Camera *)camera {
    [[FirebaseManager sharedManager] addSubscriptionToURL:[NSString stringWithFormat:@"devices/cameras/%@/", camera.cameraId] withBlock:^(FDataSnapshot *snapshot) {
        [self updateCamera:camera forStructure:snapshot.value];
    }];
}

- (void)updateCamera:(Camera *)camera forStructure:(NSDictionary *)structure
{
    if ([structure objectForKey:CAMERA_NAME]) {
        camera.name = [structure objectForKey:CAMERA_NAME];
    }
    
    if ([structure objectForKey:LAST_CAMERA_EVENT]) {
        NSDictionary *lastEventDict = [structure objectForKey:LAST_CAMERA_EVENT];
        if ([lastEventDict objectForKey:IMAGE_URL]) {
            camera.lastEventImageUrl = [lastEventDict objectForKey:IMAGE_URL];
        }
        if ([lastEventDict objectForKey:END_TIME]) {
            camera.lastEventDate = [lastEventDict objectForKey:END_TIME];
        }
    }
    
    [self.delegate cameraValuesChanged:camera];
}

@end
