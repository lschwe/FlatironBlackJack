//
//  Bet.m
//  BlackJack
//
//  Created by Nadia Yudina on 3/3/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "Bet.h"

@implementation Bet

- (id)init
{
    self = [super init];
    if (self) {
        _moneyLeft = 200;
    }
    return self;
}

-(void)updateMoneyLost:(NSInteger)playersBet
{
    self.moneyLeft = self.moneyLeft - playersBet;
}

-(void)updateMoneyWon:(NSInteger)playersBet
{
    self.moneyLeft = self.moneyLeft + playersBet;
}

@end
