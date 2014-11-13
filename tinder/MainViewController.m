//
//  MainViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/12/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "MatchScreenViewController.h"
#import "PreferencesViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Current User: %@", [PFUser currentUser]);
}

- (void)viewDidAppear:(BOOL)animated {
    [User setUpWithCompletion:^{
        User* user = [User user];
        if (user.preferences_set) {
            NSLog(@"We can directly go to matching!");
            MatchScreenViewController* mvc = [[MatchScreenViewController alloc] init];
            [self presentViewController:mvc animated:YES completion:nil];
        } else {
            NSLog(@"We need to set the preferences!");
            PreferencesViewController* pvc = [[PreferencesViewController alloc] init];
            [self presentViewController:pvc animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
