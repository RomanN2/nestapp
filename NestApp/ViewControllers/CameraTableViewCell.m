//
//  CameraTableViewCell.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "CameraTableViewCell.h"
#import "Camera.h"
#import "DateUtils.h"

@interface CameraTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *cameraNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastEventLabel;
@property (nonatomic, weak) IBOutlet UIButton *lastImageButton;
@end

@implementation CameraTableViewCell

- (void)awakeFromNib {
    self.lastImageButton.layer.cornerRadius = self.lastImageButton.frame.size.height / 2.;
    self.lastImageButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.].CGColor;
    self.lastImageButton.layer.borderWidth = 1.;
}

- (void)setCamera:(Camera *)value {
    _camera = value;
    [self updateCameraValues];
}

- (void)updateCameraValues {
    self.cameraNameLabel.text = self.camera.name;
    self.lastEventLabel.text = [DateUtils mediumDateFormatFromUTC:self.camera.lastEventDate];
}

- (IBAction)onLastImageAction:(id)sender {
    [self.delegate cameraLastImageDidPress:self.camera];
}

@end
