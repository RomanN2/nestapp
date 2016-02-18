//
//  ThermostatTableViewCell.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/15/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "ThermostatTableViewCell.h"
#import "Thermostat.h"
#import "Texts.h"
#import "NestThermostatManager.h"

@interface ThermostatTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *valuesBackgroundView;
@property (nonatomic, weak) IBOutlet UILabel *currentTemperatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTemperatureValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *targetTemperatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *targetTemperatureValueLabel;
@property (nonatomic, weak) IBOutlet UISlider *targetTemperatureSlider;
@end

@implementation ThermostatTableViewCell

- (void)awakeFromNib {
    self.valuesBackgroundView.layer.cornerRadius = 7.;
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%@", [Texts currentTemperature]];
    self.targetTemperatureLabel.text = [NSString stringWithFormat:@"%@", [Texts targetTemperature]];
}

- (void)setThermostat:(Thermostat *)value {
    _thermostat = value;
    [self updateThermostatValues];
}

- (void)updateThermostatValues {
    self.nameLabel.text = self.thermostat.nameLong;
    self.currentTemperatureValueLabel.text = [NSString stringWithFormat:@"%ld", [self.thermostat ambientTemperatureF]];
    self.targetTemperatureValueLabel.text = [NSString stringWithFormat:@"%ld", [self.thermostat targetTemperatureF]];
    self.targetTemperatureSlider.value = [self.thermostat targetTemperatureF];
}

- (IBAction)onTargetTemperatureValueChanged:(id)sender {
    self.targetTemperatureValueLabel.text = [NSString stringWithFormat:@"%d", (int)(self.targetTemperatureSlider.value)];
}

- (IBAction)onTargetTemperatureValueChangingEnded:(id)sender {
    self.thermostat.targetTemperatureF = self.targetTemperatureSlider.value;
    [self.nestThermostatManager saveChangesForThermostat:self.thermostat];
}

@end
