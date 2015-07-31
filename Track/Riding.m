//
//  Riding.m
//  Track
//
//  Created by 諶俭 on 15/7/29.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "Riding.h"

@implementation Riding

- (NSString *)description{
    return [NSString stringWithFormat:@"id  : %d startTime : %@ data : %@", self.rid, self.date, self.locations];
}

@end
