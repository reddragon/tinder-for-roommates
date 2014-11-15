//
//  SettingsViewController.h
//  tinder
//
//  Created by Chia-Chi Lin on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface SettingsViewController : UIViewController<MainViewControllerDelegate>

- (ViewType)viewType;

@end
