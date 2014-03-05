//
//  FISBlackJackGame.m
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "FISBlackJackGame.h"
#import "FISPlayingCardDeck.h"
#import "Card.h"

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
    
        // start with 200 bucks
        _chips = @200;
        // start with 5 bucks bets
        _currentBet = @50;
 
        // start with doubldown false
        _isDoubleDown = NO;
        
        // initialize cardCount
        _cardCount = @0;

    }
    return self;
}

// should deal 2 new cards, add the cards to the hand, and add the card's value to the handscore.
- (void)deal
{
    self.isDoubleDown = NO;
    
    if ([self.chips floatValue] - [self.currentBet floatValue] >= 0) {
        
        srand48(time(0));
        self.player.hand = [NSMutableArray new];
        self.dealerPlayer.hand = [NSMutableArray new];
        [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
        [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
        [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
        [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
        
        //    testing when dealer gets soft 17
        //    PlayingCard *ace = [[PlayingCard alloc] initWithRank:@1 Suit:@"♠"];
        //    PlayingCard *six = [[PlayingCard alloc] initWithRank:@6 Suit:@"♠"];
        //    [self.dealerPlayer.hand addObjectsFromArray:@[ace,six]];
        
        [self updateScore];
    } else {
        NSLog(@"no money left");
    }
}

- (void)hit
{
    srand48(time(0));
    [self.player.hand addObject:[self.playingCardDeck drawRandomCard]];
    
    [self countCard:[self.player.hand lastObject]];
    
    [self updateScore];
}

- (void)stay
{
    if (!self.player.isBusted && !self.player.isBlackjack) {
        srand48(time(0));
        
        NSInteger AceCount = 0;
        for (PlayingCard *card in self.dealerPlayer.hand) {
            if ([card.rank  isEqual: @1]){
                AceCount ++;
            }
        }
//        NSLog(@"%@", self.dealerPlayer.hand);
        
        if ([self.dealerPlayer.handScore integerValue] == 17 && AceCount > 0) {
            [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
            [self updateScore];
//            NSLog(@"soft 17");
//            NSLog(@"%@",[self.dealerPlayer.hand lastObject]);
        }
        
        while ([self.dealerPlayer.handScore integerValue] < 17) {
            [self.dealerPlayer.hand addObject:[self.playingCardDeck drawRandomCard]];
            [self updateScore];
//            NSLog(@"%@",[self.dealerPlayer.hand lastObject]);
        }
    }
    
    NSMutableArray *dealerFinalHand = [NSMutableArray arrayWithArray:self.dealerPlayer.hand];
    [dealerFinalHand removeObjectAtIndex:1];
    for (PlayingCard *card in dealerFinalHand) {
        [self countCard:card];
    }
}

- (void)updateScore
{
    for (BlackJackPlayer *currentPlayer in @[self.player, self.dealerPlayer]) {
        currentPlayer.isBusted = NO;
        currentPlayer.isBlackjack = NO;
        
        NSInteger score = 0;
        NSSortDescriptor *sortByRank = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:NO];
        NSArray *currentHandInOrder = [currentPlayer.hand sortedArrayUsingDescriptors:@[sortByRank]];
        NSInteger aceCount = 0;
        
        for (PlayingCard *card in currentHandInOrder) {
            NSInteger cardScore = [card.rank integerValue];
            if (cardScore > 10) {
                cardScore = 10;
            }
            if (cardScore == 1) {
                aceCount = aceCount + 1;
                cardScore = 11;
            }
            score += cardScore;
        }
        
        while (aceCount > 0 && score > 21) {
            score = score - 10;
            aceCount = aceCount -1;
        }
        
        currentPlayer.handScore = @(score);
        
        if ([currentPlayer.handScore isEqualToNumber:@21] && [currentPlayer.hand count] == 2) {
            currentPlayer.isBlackjack = YES;
        }
        
        if ([currentPlayer.handScore integerValue] > 21) {
            currentPlayer.isBusted = YES;
        }
//        NSLog(@"%@", currentPlayer.handScore);
//        NSLog(@"%d", currentPlayer.isBlackjack);
//        NSLog(@"%d", currentPlayer.isBusted);
        
//        NSLog(@"Chips are: %@", self.chips);
        
    }
}

- (void)increaseCardCount
{
    self.cardCount = @([self.cardCount integerValue]+1);
}

- (void)decreaseCardCount
{
    self.cardCount = @([self.cardCount integerValue]-1);
}

- (void)countCard:(PlayingCard *)card
{
    if ([card.rank integerValue] >= 10 || [card.rank isEqual:@1]) {
        [self decreaseCardCount];
    } else if ([card.rank integerValue] <= 6 && ![card.rank isEqual:@1]) {
        [self increaseCardCount];
    }
}
@end
