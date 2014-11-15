//
//  MainViewController.h
//  tinder
//
//  Created by Gaurav Menghani on 11/12/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewType.h"

@protocol MainViewControllerDelegate

- (ViewType)viewType;

@end

@interface MainViewController : UIViewController

@end
