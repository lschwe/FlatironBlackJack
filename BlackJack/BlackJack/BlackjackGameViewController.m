//
//  BlackjackGameViewController.m
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "BlackjackGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BlackjackGameViewController ()


@end

@implementation BlackjackGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pokerFeltBackground320x568"]];
    self.view.backgroundColor = UIColorFromRGB(0x2cc36b);
    
    PlayingCardView *deckCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(60, 100, cardWidth, cardHeight) withRank:@"2" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(63, 103, cardWidth, cardHeight) withRank:@"3" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard3 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:@"4" withSuit:@"♥" isVisible:NO];
//    PlayingCardView *dealerCardHidden = [[PlayingCardView alloc] initWithFrame:CGRectMake(170, 100, cardWidth, cardHeight) withRank:@"5" withSuit:@"♥" isVisible:NO];
//    PlayingCardView *dealerCardVisible = [[PlayingCardView alloc] initWithFrame:CGRectMake(185, 115, cardWidth, cardHeight) withRank:@"6" withSuit:@"♥" isVisible:YES];
//    PlayingCardView *playerCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:@"K" withSuit:@"♣" isVisible:NO];
//    PlayingCardView *playerCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:@"A" withSuit:@"♣" isVisible:NO];
    
    [self.view addSubview:deckCard1];
    [self.view addSubview:deckCard2];
    [self.view addSubview:deckCard3];
//    [self.view addSubview:dealerCardHidden];
//    [self.view addSubview:dealerCardVisible];
//    [self.view addSubview:playerCard1];
//    [self.view addSubview:playerCard2];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        playerCard1.frame = CGRectMake(60, 300, cardWidth, cardHeight);
//    } completion:^(BOOL finished){
//        [playerCard1 flipCard];
//        [UIView animateWithDuration:0.3 animations:^{
//            playerCard2.frame = CGRectMake(80, 320, cardWidth, cardHeight);
//        } completion:^(BOOL finished){
//            [playerCard2 flipCard];
//        }];
//    }];
    
    
    
    
    self.blackJackGame = [[FISBlackJackGame alloc] init];
    
    
    [self deal:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hit:(id)sender {
    NSLog(@"Hit was tapped");
    [self.blackJackGame hit];
    if([self.blackJackGame.player.hand count] > 2) {
        self.card3.text = [self.blackJackGame.player.hand[2] description];
        self.card3.hidden = NO;

    }
    if([self.blackJackGame.player.hand count] > 3) {
        self.card4.text = [self.blackJackGame.player.hand[3] description];
        self.card4.hidden = NO;
    }
    if([self.blackJackGame.player.hand count] > 4) {
        self.card5.text = [self.blackJackGame.player.hand[4] description];
        self.card5.hidden = NO;
    }
    
    [self updateLabels];
}

- (IBAction)deal:(id)sender {
    
    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;
    
    self.hitButton.enabled = YES;
    self.stayButton.enabled = YES;
//    self.card3.hidden = YES;
//    self.card4.hidden = YES;
//    self.card5.hidden = YES;
    self.result.hidden = YES;
    
    if ([self.blackJackGame.playingCardDeck.cards count] < 20) {
        CGFloat chipCount = [self.blackJackGame.chips floatValue];
        self.blackJackGame = [FISBlackJackGame new];
        self.blackJackGame.chips = @(chipCount);
        self.result.text = @"Fresh Deck";
        self.result.hidden = NO;
    }
    
    [self.blackJackGame deal];
    NSString *playerCard1Rank = [self.blackJackGame.player.hand[0] formattedCardRank];
    NSString *playerCard2Rank = [self.blackJackGame.player.hand[1] formattedCardRank];
    PlayingCard *playerCard1 = self.blackJackGame.player.hand[0];
    NSString *playerCard1Suit = playerCard1.suit;
    PlayingCard *playerCard2 = self.blackJackGame.player.hand[1];
    NSString *playerCard2Suit = playerCard2.suit;
    
    NSString *dealerCard1Rank = [self.blackJackGame.dealerPlayer.hand[0] formattedCardRank];
    NSString *dealerCard2Rank = [self.blackJackGame.dealerPlayer.hand[1] formattedCardRank];
    PlayingCard *dealerCard1 = self.blackJackGame.dealerPlayer.hand[0];
    NSString *dealerCard1Suit = dealerCard1.suit;
    PlayingCard *dealerCard2 = self.blackJackGame.dealerPlayer.hand[1];
    NSString *dealerCard2Suit = dealerCard2.suit;
    
    PlayingCardView *playerCardView1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:playerCard1Rank withSuit:playerCard1Suit isVisible:NO];
    PlayingCardView *playerCardView2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:playerCard2Rank withSuit:playerCard2Suit isVisible:NO];
    
    
    PlayingCardView *dealerCardView1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:dealerCard1Rank withSuit:dealerCard1Suit isVisible:NO];
    PlayingCardView *dealerCardView2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:dealerCard2Rank withSuit:dealerCard2Suit isVisible:NO];
    
    [self.view addSubview:playerCardView1];
    [self.view addSubview:playerCardView2];
    [self.view addSubview:dealerCardView1];
    [self.view addSubview:dealerCardView2];
    
    [UIView animateWithDuration:0.3 animations:^{
        playerCardView1.frame = CGRectMake(60, 300, cardWidth, cardHeight);
    } completion:^(BOOL finished){
        [playerCardView1 flipCard];
        [UIView animateWithDuration:0.3 animations:^{
            dealerCardView1.frame = CGRectMake(170, 100, cardWidth, cardHeight);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 animations:^{
                playerCardView2.frame = CGRectMake(80, 320, cardWidth, cardHeight);
            } completion:^(BOOL finished){
                [playerCardView2 flipCard];
                [UIView animateWithDuration:0.3 animations:^{
                    dealerCardView2.frame = CGRectMake(190, 120, cardWidth, cardHeight);
                } completion:^(BOOL finished){
                    [dealerCardView2 flipCard];
                }];
            }];
        }];
    }];
//    
//    self.card1.text = [self.blackJackGame.player.hand[0] description];
//    self.card2.text = [self.blackJackGame.player.hand[1] description];
//    self.card1.hidden = NO;
//    self.card2.hidden = NO;
    
    [self updateLabels];
    NSLog(@"Player has %@ chips and is currently betting %@", self.blackJackGame.chips, self.blackJackGame.currentBet);
}

- (IBAction)stay:(id)sender {
    [self.blackJackGame stay];
    self.stayButton.enabled = NO;
    NSString *winner = @"";
    CGFloat multiple = 1;
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    if (([self.blackJackGame.player.handScore integerValue] > [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) || (self.blackJackGame.dealerPlayer.isBusted == YES && self.blackJackGame.player.isBusted == NO)) {
        if (self.blackJackGame.player.isBlackjack) {
            self.result.text = @"Player Wins with Black Jack!";
            winner = @"Player";
        } else {
            self.result.text = @"Player Wins";
            winner = @"Player";
        }
        self.result.hidden = NO;
    } else if ([self.blackJackGame.player.handScore integerValue] == [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) {
        self.result.text = @"Push";
        self.result.hidden = NO;
    } else {
        if (self.blackJackGame.player.isBusted) {
            self.result.text = @"Player Busted and Dealer Wins";
            winner = @"Dealer";
        } else {
            self.result.text = @"Dealer Wins";
            winner = @"Dealer";
        }
        self.result.hidden = NO;
    }
    
    if ([winner isEqualToString:@"Player"]) {
        if (self.blackJackGame.player.isBlackjack) {
            multiple = 1.5;
        }
        self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] + [self.blackJackGame.currentBet floatValue]*multiple);
        NSLog(@"Player has won %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
    } else if ([winner isEqualToString:@"Dealer"]){
        self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue]);
        NSLog(@"Player has lost %@ chips. Now he has %@", self.blackJackGame.currentBet, self.blackJackGame.chips);
    } else {
        NSLog(@"Push. Player keeps his %@ chips", self.blackJackGame.chips);
    }
}

- (void)updateLabels
{
    self.score.text = [NSString stringWithFormat:@"%@", self.blackJackGame.player.handScore];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    PlayingCard *dealerCard = self.blackJackGame.dealerPlayer.hand[0];
    self.dealerFirstCard.text = [NSString stringWithFormat:@"%@", dealerCard.rank];
    if (self.blackJackGame.player.isBlackjack) {
        self.result.text = @"Blackjack!";
        self.result.hidden = NO;
        self.hitButton.enabled = NO;
        [self stay:nil];
    }
    
    if (self.blackJackGame.player.isBusted) {
        self.result.text = @"Busted!";
        self.result.hidden = NO;
        self.hitButton.enabled = NO;
        [self stay:nil];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertView *shakeAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to change tables?" message:@"Click OK to quit the current game and deal fresh decks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [shakeAlert show];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex){
        
    }else{
        [self.blackJackGame.playingCardDeck.cards removeAllObjects];
        [self deal:nil];
    }
}

@end
