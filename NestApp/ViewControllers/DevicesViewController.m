//
//  DevicesViewController.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "DevicesViewController.h"
#import "Texts.h"
#import "NestThermostatManager.h"
#import "NestStructureManager.h"
#import "ThermostatTableViewCell.h"
#import "NestCameraManager.h"
#import "Camera.h"
#import "CameraTableViewCell.h"
#import "LastCameraImageViewController.h"

@interface DevicesViewController () <NestThermostatManagerDelegate, NestStructureManagerDelegate, UITableViewDataSource, UITableViewDelegate, NestCameraManagerDelegate, CameraCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *devicesTableView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingSpinner;

@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;
@property (nonatomic, strong) NestCameraManager *nestCameraManager;
@property (nonatomic, strong) NestStructureManager *nestStructureManager;
@property (nonatomic, strong) NSArray *thermostats;
@property (nonatomic, strong) NSArray *cameras;

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [Texts devices];
    
    [self loadDevices];
}

- (void)loadDevices {
    [self.loadingSpinner startAnimating];
    [self.nestStructureManager initialize];
}

- (void)updateUIAfterThermostasWereLoaded {
    self.messageLabel.hidden = (self.thermostats.count > 0);
    self.devicesTableView.hidden = (self.thermostats.count == 0);
    [self.loadingSpinner stopAnimating];
    [self.devicesTableView reloadData];
}

- (void)subscribeForThermostats {
    for (Thermostat *thermostat in self.thermostats) {
        [self.nestThermostatManager beginSubscriptionForThermostat:thermostat];
    }
}

- (void)subscribeForCameras {
    for (Camera *camera in self.cameras) {
        [self.nestCameraManager beginSubscriptionForCamera:camera];
    }
}

- (NestThermostatManager*)nestThermostatManager {
    if (!_nestThermostatManager) {
        _nestThermostatManager = [NestThermostatManager new];
        _nestThermostatManager.delegate = self;
    }
    return _nestThermostatManager;
}

- (NestStructureManager*)nestStructureManager {
    if (!_nestStructureManager) {
        _nestStructureManager = [NestStructureManager new];
        _nestStructureManager.delegate = self;
    }
    return _nestStructureManager;
}

- (NestCameraManager*)nestCameraManager {
    if (!_nestCameraManager) {
        _nestCameraManager = [NestCameraManager new];
        _nestCameraManager.delegate = self;
    }
    return _nestCameraManager;
}

#pragma mark - UITableViewDataSource + UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // one for thermostats and second for cameras
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.thermostats.count : self.cameras.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0)
        ? [self thermostatCellForRowAtIndexPath:indexPath]
        : [self cameraCellForRowAtIndexPath:indexPath];
    
}

- (UITableViewCell*)thermostatCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"ThermostatCell";
    ThermostatTableViewCell *cell = (ThermostatTableViewCell*)[self.devicesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Thermostat *thermostat = [self.thermostats objectAtIndex:indexPath.row];
    cell.thermostat = thermostat;
    cell.nestThermostatManager = self.nestThermostatManager;
    
    return cell;
}

- (UITableViewCell*)cameraCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"CameraCell";
    CameraTableViewCell *cell = (CameraTableViewCell*)[self.devicesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.camera = [self.cameras objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? [Texts thermostats] : @"Cameras";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 180. : 55.;
}

#pragma mark - NestThermostatManagerDelegate Methods

- (void)thermostatValuesChanged:(Thermostat *)thermostat {
    
    NSInteger index = [self.thermostats indexOfObject:thermostat];
    if (index != NSNotFound) {
        NSIndexPath *pathToUpdate = [NSIndexPath indexPathForItem:index inSection:0];
        [self.devicesTableView reloadRowsAtIndexPaths:@[pathToUpdate] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - NestCameraManagerDelegate

- (void)cameraValuesChanged:(Camera *)camera {
    NSInteger index = [self.cameras indexOfObject:camera];
    if (index != NSNotFound) {
        NSIndexPath *pathToUpdate = [NSIndexPath indexPathForItem:index inSection:1];
        [self.devicesTableView reloadRowsAtIndexPaths:@[pathToUpdate] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - NestStructureManagerDelegate Methods

- (void)structureUpdated:(NSDictionary *)structure
{
    // Save received thermostats
    if ([structure objectForKey:@"thermostats"]) {
        self.thermostats = [structure objectForKey:@"thermostats"];
    }
    if ([structure objectForKey:@"cameras"]) {
        self.cameras = [structure objectForKey:@"cameras"];
    }
    if (self.thermostats.count == 0 && self.cameras.count == 0) {
        [self.messageLabel setText:[Texts noThermostatsMessage]];
    }
 
    // Update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIAfterThermostasWereLoaded];
    });
    
    // Subscribe to receive notifications from devices
    [self subscribeForThermostats];
    [self subscribeForCameras];
}

#pragma mark - CameraCellDelegate

- (void)cameraLastImageDidPress:(Camera*)camera {
    LastCameraImageViewController *imageVC = (LastCameraImageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LastCameraImageView"];
    imageVC.camera = camera;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imageVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
