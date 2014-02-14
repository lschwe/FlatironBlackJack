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
        _player = [[BlackJackPlayer alloc] init];
        _dealerPlayer = [[BlackJackPlayer alloc] init];
        _player.handScore = @0;
        _player.isBusted = NO;
        _player.isBlackjack = NO;
        _player.hand = [NSMutableArray new];
        _dealerPlayer.handScore = @0;
        _dealerPlayer.isBusted = NO;
        _dealerPlayer.isBlackjack = NO;
        _dealerPlayer.hand = [NSMutableArray new];
    }
    return self;
}

// should deal 2 new cards, add the cards to the hand, and add the card's value to the handscore.
- (void)deal
{
    srand48(time(0));
    self.playingCardDeck = [FISPlayingCardDeck new];
    self.player.hand = [NSMutableArray new];
    self.dealerPlayer.hand = [NSMutableArray new];
    [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self updateScore];
}

- (void)hit
{
    srand48(time(0));
    [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
    [self updateScore];
}

- (void)stay
{
    srand48(time(0));
    while ([self.dealerPlayer.handScore integerValue] < 17) {
        [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
        [self updateScore];
    }
}

- (void)updateScore
{
    for (BlackJackPlayer *currentPlayer in @[self.player, self.dealerPlayer]) {
        currentPlayer.isBusted = NO;
        currentPlayer.isBlackjack = NO;
        
        NSInteger score = 0;
        for (PlayingCard *card in currentPlayer.hand) {
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
        currentPlayer.handScore = @(score);
        
        if ([currentPlayer.handScore isEqualToNumber:@21] && [currentPlayer.hand count] == 2) {
            currentPlayer.isBlackjack = YES;
        }
        
        if ([currentPlayer.handScore integerValue] > 21) {
            currentPlayer.isBusted = YES;
        }
        
    }
}


@end
