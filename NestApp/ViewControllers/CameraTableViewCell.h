//
//  CameraTableViewCell.h
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Camera;

@protocol CameraCellDelegate <NSObject>

- (void)cameraLastImageDidPress:(Camera*)camera;

@end

@interface CameraTableViewCell : UITableViewCell
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, weak) id<CameraCellDelegate> delegate;
@end
