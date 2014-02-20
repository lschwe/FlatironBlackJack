//
//  PlayingCard.m
//  OOP-Cards-Model
//
//  Created by Andrea McClave on 2/10/14.
//  Copyright (c) 2014 Al Tyus. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (id)initWithRank:(NSNumber *)rankNumber Suit:(NSString *)suitString
{
    self = [super init];
    if (self) {
        if ([self validRank:rankNumber]) {
            _rank = rankNumber; }
        else {
            _rank = @0;
        }
        if ([self validSuit:suitString]) {
          _suit = suitString;
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSString *rankString = [NSString stringWithFormat:@"%@",self.rank];
    
    if ([self.rank integerValue] == 11) {
        rankString = @"J";
    } else if ([self.rank integerValue] == 12) {
        rankString = @"Q";
    } else if ([self.rank integerValue] == 13) {
        rankString = @"K";
    } else if ([self.rank integerValue] == 1) {
        rankString = @"A";
    }
    
    return [NSString stringWithFormat:@"%@%@", rankString, self.suit];
}

- (BOOL)validRank:(NSNumber *)rank
{
    if ([rank integerValue]  >= 1 && [rank integerValue] <= 13 && strcmp([rank objCType], @encode(int)) == 0) {
        return YES;
    } else {
        NSLog(@"Rank not valid");
        return NO;
    }
}

- (BOOL)validSuit:(NSString *)suit
{
    if ([suit isEqualToString:@"♥"] || [suit isEqualToString: @"♠"] || [suit isEqualToString: @"♣"] || [suit isEqualToString: @"♦"]) {
        return YES;
    } else {
        NSLog(@"Suit not valid");
        return NO;
    }
}



@end
