//
//  FISDeck.m
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "FISDeck.h"


@implementation FISDeck

- (id)initWithCards: (NSMutableArray *)cards
{
    self = [super init];
    if (self) {
        _cards = cards;
    }
    return self;
}

- (Card *)drawRandomCard
{
    srand48(time(0));
    NSInteger indexOfCard = floor(drand48() * [self.cards count]);
    Card *result = [self.cards objectAtIndex:indexOfCard];
    [self.cards removeObjectAtIndex:indexOfCard];
    return result;
}

@end
