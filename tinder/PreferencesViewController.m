//
//  PreferencesViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/13/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "PreferencesViewController.h"
#import "User.h"

@interface PreferencesViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nameLabel setText:[[User user] name]];
    [self.locationLabel setText:[[User user] location]];
    // [self.genderLabel setText:[[User user] gender]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
