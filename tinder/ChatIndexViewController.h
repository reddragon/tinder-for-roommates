//
//  ChatIndexViewController.h
//  tinder
//
//  Created by Alan McConnell on 11/13/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ChatIndexViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate>

- (ViewType)viewType;

@end
