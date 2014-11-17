//
//  ShowMatchVC.m
//  tinder
//
//  Created by Gaurav Menghani on 11/16/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ShowMatchVC.h"

@interface ShowMatchVC ()
@property User* matchingUser;
@property (strong, nonatomic) IBOutlet UILabel *matchingUserName;
@end

@implementation ShowMatchVC

- (id)initWithMatchingUser:(User*)user {
    self.matchingUser = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matchingUserName.text = self.matchingUser.name;
    // Do any additional setup after loading the view from its nib.
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
