//
//  Match.m
//  tinder
//
//  Created by Alan McConnell on 11/14/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "Match.h"

@implementation Match

- (id)initWithMatch:(User *)match date:(NSDate *)date {
    self = [super init];
    if (self) {
        _match = match;
        _date = date;
    }
    return self;
}

@end
