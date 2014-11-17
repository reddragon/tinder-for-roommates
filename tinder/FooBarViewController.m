//
//  FooBarViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/16/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "FooBarViewController.h"

@interface FooBarViewController ()
@property (strong, nonatomic) IBOutlet UILabel *texLabel;

@end

@implementation FooBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIView animateWithDuration:3.0 animations:^{
        self.texLabel.center = CGPointMake(self.texLabel.center.x + 100, self.texLabel.center.y + 100);
    }];
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
