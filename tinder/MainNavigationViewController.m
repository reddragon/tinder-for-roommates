//
//  MainNavigationViewController.m
//  tinder
//
//  Created by Alan McConnell on 11/15/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MainNavigationViewController.h"
#import "SettingsViewController.h"
#import "ChatIndexViewController.h"
#import "MatchScreenViewController.h"

@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    
    MatchScreenViewController *mvc = [[MatchScreenViewController alloc] init];
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    ChatIndexViewController *cvc = [[ChatIndexViewController alloc] init];
    
    [_pageController setViewControllers:@[svc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [_pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
