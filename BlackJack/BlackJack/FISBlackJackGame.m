//
//  FISBlackJackGame.m
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "FISBlackJackGame.h"
#import "FISPlayingCardDeck.h"
#import "PlayingCard.h"

@implementation FISBlackJackGame

// should initialize playingCardDeck with a new deck and set score and isBusted to default values
- (id)init
{
    self = [super init];
    if (self) {
        _playingCardDeck = [FISPlayingCardDeck new];
        _handScore = @0;
        _isBusted = NO;
        _isBlackjack = NO;
        _hand = [NSMutableArray new];
    }
    return self;
}

// should deal 2 new cards, add the cards to the hand, and add the card's value to the handscore.
- (void)deal
{
    srand48(time(0));
    self.playingCardDeck = [FISPlayingCardDeck new];
    self.hand = [NSMutableArray new];
    [self.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self updateScore];
}

- (void)hit
{
    srand48(time(0));
    [self.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self updateScore];
}

- (void)updateScore
{
    self.isBusted = NO;
    self.isBlackjack = NO;
    
    NSInteger score = 0;
    for (PlayingCard *card in self.hand) {
        NSInteger cardScore = [card.rank integerValue];
        if (cardScore > 10) {
            cardScore = 10;
        }
        if (cardScore == 1) {
            cardScore = 11;
            if (score + cardScore > 21) {
                cardScore = 1;
            }
        }
        score += cardScore;
    }
    self.handScore = @(score);
    
    if ([self.handScore isEqualToNumber:@21] && [self.hand count] == 2) {
        self.isBlackjack = YES;
    }
    
    if ([self.handScore integerValue] > 21) {
        self.isBusted = YES;
    }
}

@end
