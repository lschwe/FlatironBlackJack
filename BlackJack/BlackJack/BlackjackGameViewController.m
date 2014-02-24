//
//  BlackjackGameViewController.m
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "BlackjackGameViewController.h"
#import "PlayingCard.h"

@interface BlackjackGameViewController ()

@property (strong, nonatomic) UIAlertView *shakeAlert;

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
    
    self.hitButton.enabled = YES;
    self.card3.hidden = YES;
    self.card4.hidden = YES;
    self.card5.hidden = YES;
    self.result.hidden = YES;
    
    if ([self.blackJackGame.playingCardDeck.cards count] < 20) {
        self.blackJackGame = [FISBlackJackGame new];
        self.result.text = @"Fresh Deck";
        self.result.hidden = NO;
    }
    
    NSLog(@"Deal was tapped");
    [self.blackJackGame deal];
    self.card1.text = [self.blackJackGame.player.hand[0] description];
    self.card2.text = [self.blackJackGame.player.hand[1] description];
    self.card1.hidden = NO;
    self.card2.hidden = NO;
    
    [self updateLabels];
}

- (IBAction)stay:(id)sender {
    [self.blackJackGame stay];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    if (([self.blackJackGame.player.handScore integerValue] > [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) || (self.blackJackGame.dealerPlayer.isBusted == YES && self.blackJackGame.player.isBusted == NO)) {
        if (self.blackJackGame.player.isBlackjack) {
            self.result.text = @"Player Wins with Black Jack!";
        } else {
            self.result.text = @"Player Wins";
        }
        self.result.hidden = NO;
    } else if ([self.blackJackGame.player.handScore integerValue] == [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) {
        self.result.text = @"Push";
        self.result.hidden = NO;
    } else {
        if (self.blackJackGame.player.isBusted) {
            self.result.text = @"Player Busted and Dealer Wins";
        } else {
            self.result.text = @"Dealer Wins";
        }
        self.result.hidden = NO;
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
        self.shakeAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to change tables?" message:@"Click OK to quit the current game and deal fresh decks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [self.shakeAlert show];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self.shakeAlert cancelButtonIndex]){
        
    }else{
        [self.blackJackGame.playingCardDeck.cards removeAllObjects];
        [self deal:nil];
    }
}

@end
