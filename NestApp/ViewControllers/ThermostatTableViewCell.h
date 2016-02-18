//
//  ThermostatTableViewCell.h
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thermostat;
@class NestThermostatManager;
@interface ThermostatTableViewCell : UITableViewCell

@property (nonatomic, strong) Thermostat *thermostat;
@property (nonatomic, weak) NestThermostatManager *nestThermostatManager;
@end
