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
#import "CEPopupPickerView.h"
#import "Bet.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSInteger const cardWidth = 80;
static NSInteger const cardHeight = 112;
static NSInteger const chipSize = 50;
const CGRect playerRect = {{20, 320}, {cardWidth,cardHeight}};
const CGRect deckRect = {{220, 76}, {cardWidth,cardHeight}};
const CGRect dealerRect = {{20, 70}, {cardWidth,cardHeight}};
const CGRect betStartRect = {{240, 350}, {chipSize,chipSize}};
const CGRect betEndRect = {{50, 255}, {chipSize,chipSize}};
const CGRect ddEndRect = {{100, 255}, {chipSize,chipSize}};

@interface BlackjackGameViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *helpBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hintBarButton;
@property (weak, nonatomic) IBOutlet UIView *currentCardsView;
@property (nonatomic) CEPopupPickerView *betPicker;
@property (strong, nonatomic) FISBlackJackGame *blackJackGame;
@property (strong, nonatomic) CWStatusBarNotification *notification;
@property (strong, nonatomic) UILabel *betLabel;
@property (strong, nonatomic) UILabel *ddLabel;
@property (strong, nonatomic) UIView *pickerView;
@property (nonatomic) BOOL isAiMode;

- (IBAction)doubleDownTapped:(id)sender;
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
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Set up gesture recognizers
    UISwipeGestureRecognizer* swipeOnView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(stay:)];
    swipeOnView.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeOnView];
    
    // Setup notification bar
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = [UIColor whiteColor];
    self.notification.notificationLabelTextColor = [UIColor blackColor];
    
    // Setup AI Mode
    self.isAiMode = NO;
    
    [self layoutGame];
    self.blackJackGame = [[FISBlackJackGame alloc] init];
    [self deal:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Overrides

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Gestures / Motion

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        
        UIAlertView *shakeAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to change tables?"
                                                            message:@"Click OK to quit the current game and reshuffle."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        
        shakeAlert.tag = 1;
        
        [shakeAlert show];
        
        
    }
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2) {
        if (buttonIndex == alertView.cancelButtonIndex){
            
        }else{
            
            self.blackJackGame = [FISBlackJackGame new];
            self.blackJackGame.chips = @200;
            [self.notification displayNotificationWithMessage:@"Shuffling" forDuration:1];
            
            [self deal:nil];
        }
    } else if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex){
            
        }else{
            CGFloat chipCount = [self.blackJackGame.chips floatValue];
            self.blackJackGame = [FISBlackJackGame new];
            self.blackJackGame.chips = @(chipCount);
            [self.notification displayNotificationWithMessage:@"Shuffling" forDuration:1];
            
            [self deal:nil];
        }
    }
    
}

#pragma mark - IBActions


- (IBAction)betButtonTapped:(UIButton *)sender
{
    NSArray *betOptions = @[@"5",@"10",@"15",@"20",@"25",@"50",@"75",@"100"];
    
    __block NSMutableString *bet = [[NSMutableString alloc]init];
    
    self.betPicker = [[CEPopupPickerView alloc] initWithValues:betOptions callback:^(NSInteger selectedIndex) {
        
        bet = [betOptions objectAtIndex:selectedIndex];
        
        [self updateBet:[betOptions objectAtIndex:selectedIndex]];
        [self.pickerView removeFromSuperview];
        
    }];
    
    self.pickerView = [[UIView alloc]initWithFrame:self.view.frame];
    self.pickerView.alpha = 0.5;
    self.pickerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pickerView];
    [self.betPicker presentInView:self.view];
    
}

- (IBAction)doubleDownTapped:(id)sender {
    PlayingCardView *dealerHiddenCard = [self.currentCardsView subviews][0];
    if (!self.blackJackGame.player.isBusted && !dealerHiddenCard.isVisible && [self.blackJackGame.player.hand count]==2) {
        self.blackJackGame.isDoubleDown = YES;
//        NSLog(@"Double Down");
        FAKFontAwesome *chipIcon = [FAKFontAwesome certificateIconWithSize:chipSize];
        [chipIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x45A1CD)];
        self.ddLabel = [[UILabel alloc] initWithFrame:betStartRect];
        self.ddLabel.text = @"//";
        self.ddLabel.textColor = [UIColor whiteColor];
        self.ddLabel.attributedText = [chipIcon attributedString];
        [self.view addSubview:self.ddLabel];
        [self.view sendSubviewToBack:self.betLabel];
        [self.view sendSubviewToBack:self.ddLabel];
        [self animatebetLabel:self.ddLabel toFrame:ddEndRect onCompletion:nil];
        [self hit:nil];
        [self stay:nil];
    }
}

- (IBAction)hit:(id)sender {
    sleep(1);
//    NSLog(@"Hit was tapped");
    [self.notification dismissNotification];
    PlayingCardView *dealerHiddenCard = [self.currentCardsView subviews][0];
    if (!self.blackJackGame.player.isBusted && !dealerHiddenCard.isVisible) {
        
        [self.blackJackGame hit];
        
        // Draw card
        PlayingCardView *lastCardDrawn = [self.currentCardsView.subviews lastObject];
        PlayingCardView *playerCardView = [self drawCard:[self.blackJackGame.player.hand lastObject] withFrame:deckRect isVisible:NO];
        
        // Reset card to new line if there are too many
        CGFloat lastCardX = lastCardDrawn.frame.origin.x;
        CGFloat lastCardY = lastCardDrawn.frame.origin.y;
        if (lastCardX > 90) {
            lastCardX = -10;
            lastCardY = lastCardY +20;
        }
        
        // Draw animation
        [self animatePlayingCardView:playerCardView withFlip:YES withTilt:YES toFrame:CGRectMake(lastCardX+30, lastCardY+10, cardWidth, cardHeight) onCompletion:^{
            [self hintTapped:nil];
        }];
        
        [self updateLabels];
    }
    
//    NSLog(@"The current card count is %@", self.blackJackGame.cardCount);
    
}

- (IBAction)deal:(id)sender {
    [self.notification dismissNotification];
    PlayingCardView *dealerHiddenCard;
    
    if ([[self.currentCardsView subviews] count] > 0) {
        dealerHiddenCard = [self.currentCardsView subviews][0];
    } else {
        dealerHiddenCard = [[PlayingCardView alloc] init];
        dealerHiddenCard.isVisible = YES;
    }
    
    if (dealerHiddenCard.isVisible) {
        if ([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue] >= 0) {
            [self dealCards];
        } else {
            [self showGameOverAlert];
        }
    }
    
}


- (IBAction)stay:(id)sender {
    
    PlayingCardView *dealerHiddenCard = self.currentCardsView.subviews[0];
    if (dealerHiddenCard.isVisible == NO) {
        
        [self.blackJackGame stay];
        [dealerHiddenCard flipCard];
        self.dealerScore.hidden = NO;
        
        CGFloat xcoord = dealerRect.origin.x+30;
        CGFloat ycoord = dealerRect.origin.y+10;
        
        if ([self.blackJackGame.dealerPlayer.hand count]>2) {
            for (NSInteger i = 2; i < [self.blackJackGame.dealerPlayer.hand count]; i++) {
                if (xcoord>90) {
                    xcoord = -10;
                    ycoord = ycoord +20;
                }
                
                xcoord = xcoord +30;
                ycoord = ycoord +10;
                
                PlayingCardView *dealerCardView = [self drawCard:self.blackJackGame.dealerPlayer.hand[i] withFrame:deckRect isVisible:NO];
                [self animatePlayingCardView:dealerCardView withFlip:YES withTilt:YES toFrame:CGRectMake(xcoord, ycoord, cardWidth, cardHeight) onCompletion:nil];
            }
        }
        
        
        NSString *winner = @"";
        CGFloat multiple = 1;
        if (self.blackJackGame.isDoubleDown) {
            multiple = 2;
        }
        [self.notification dismissNotification];
        self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
        if (([self.blackJackGame.player.handScore integerValue] > [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) || (self.blackJackGame.dealerPlayer.isBusted == YES && self.blackJackGame.player.isBusted == NO)) {
            if (self.blackJackGame.player.isBlackjack) {
                [self.notification displayNotificationWithMessage:@"You got Blackjack!" completion:nil];
                multiple = 1.5;
            } else {
                [self.notification displayNotificationWithMessage:@"You Win!" completion:nil];
            }
            winner = @"Player";
        } else if ([self.blackJackGame.player.handScore integerValue] == [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) {
            [self.notification displayNotificationWithMessage:@"Push." completion:nil];
        } else {
            if (self.blackJackGame.player.isBusted) {
                [self.notification displayNotificationWithMessage:@"You Busted." completion:nil];
            } else {
                PlayingCard *dealerVisibleCard = self.blackJackGame.dealerPlayer.hand[1];
                if (self.blackJackGame.dealerPlayer.isBlackjack && [dealerVisibleCard.rank isEqual:@1]) {
                    [self.notification displayNotificationWithMessage:@"Dealer got Blackjack. :(" completion:nil];
                } else {
                    [self.notification displayNotificationWithMessage:@"You lost." completion:nil];
                }
            }
            winner = @"Dealer";
        }
        
        if ([winner isEqualToString:@"Player"]) {
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] + [self.blackJackGame.currentBet floatValue]*multiple);
            NSLog(@"Player has won %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
        
        } else if ([winner isEqualToString:@"Dealer"]){
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue]*multiple);
            
            NSLog(@"Player has lost %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
        } else {
            NSLog(@"Push. Player keeps his %@ chips", self.blackJackGame.chips);
        }
        
        self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue])];
        //                                    - [self.blackJackGame.currentBet floatValue])];
//        sleep(2);
        
        if ([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue] >= 0) {
            [self hintTapped:nil];
        }
    }
//    NSLog(@"The current card count is %@", self.blackJackGame.cardCount);
}


- (IBAction)hintTapped:(id)sender {
    if (sender) {
        if (self.isAiMode) {
            [self.notification dismissNotification];
            [self.notification displayNotificationWithMessage:@"AI MODE OFF" completion:nil];
            self.isAiMode = NO;
        } else {
            [self.notification dismissNotification];
            [self.notification displayNotificationWithMessage:@"AI MODE ON" completion:nil];
            self.isAiMode = YES;
        }
    }
    NSString *advice;
    NSInteger playerScore = [self.blackJackGame.player.handScore integerValue];
    PlayingCard *dealerCard = self.blackJackGame.dealerPlayer.hand[1];
    NSInteger dealerCardRank = [dealerCard.rank integerValue];
    NSInteger trueCount = (NSInteger)round([self.blackJackGame.cardCount floatValue]/6);
    NSInteger sumOfRanks = 0;
    for (PlayingCard *card in self.blackJackGame.player.hand) {
        sumOfRanks = sumOfRanks + [card.rank integerValue];
    }
    
    if (dealerCardRank == 1) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17,@18] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else {
                advice = @"stay";
            }
        } else if ([@[@8,@9,@10,@12,@13,@14,@15,@16] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank >= 10) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17,@18] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else {
                advice = @"stay";
            }
        } else if ([@[@8,@9,@10,@12,@13,@14,@15,@16] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 9) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17,@18] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else {
                advice = @"stay";
            }
        } else if ([@[@8,@9,@12,@13,@14,@15,@16] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 8) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else {
                advice = @"stay";
            }
        } else if ([@[@8,@9,@12,@13,@14,@15,@16] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 7) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else {
                advice = @"stay";
            }
        } else if ([@[@8,@9,@12,@13,@14,@15,@16] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 6) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else if ([@[@18,@19,@20] containsObject:@(playerScore)]) {
                advice = @"stay";
            } else {
                advice = @"double down";
            }
        } else if ([@[@8] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@9,@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 5) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else if ([@[@18,@19,@20] containsObject:@(playerScore)]) {
                advice = @"stay";
            } else {
                advice = @"double down";
            }
        } else if ([@[@8] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@9,@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 4) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else if ([@[@18,@19,@20] containsObject:@(playerScore)]) {
                advice = @"stay";
            } else {
                advice = @"double down";
            }
        } else if ([@[@8] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@9,@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 3) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else if ([@[@18,@19,@20] containsObject:@(playerScore)]) {
                advice = @"stay";
            } else {
                advice = @"double down";
            }
        } else if ([@[@8,@12] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@9,@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    } else if (dealerCardRank == 2) {
        if (playerScore - 10 == sumOfRanks) {
            if ([@[@12,@13,@14,@15,@16,@17] containsObject:@(playerScore)]) {
                advice = @"hit";
            } else if ([@[@18,@19,@20] containsObject:@(playerScore)]) {
                advice = @"stay";
            } else {
                advice = @"double down";
            }
        } else if ([@[@8,@9,@12] containsObject:@(playerScore)] || playerScore < 8) {
            advice = @"hit";
        } else if ([@[@10,@11] containsObject:@(playerScore)]) {
            advice = @"double down";
        } else {
            advice = @"stay";
        }
    }
    
    // advice considering count. also if its a soft something, it should hit.
    
    if (playerScore == 16 && dealerCardRank >= 10) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 0) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 15 && dealerCardRank >= 10 ) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 4) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 10 && dealerCardRank >= 10) {
        if (trueCount >= 4) {
            advice = @"double down";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 12 && dealerCardRank == 3) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 2) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 12 && dealerCardRank == 2) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 3) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 11 && dealerCardRank == 1) {
        if (trueCount >= 1) {
            advice = @"double down";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 9 && dealerCardRank == 2){
        if (trueCount >= 1) {
            advice = @"double down";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 10 && dealerCardRank == 1){
        if (trueCount >= 4) {
            advice = @"double down";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 9 && dealerCardRank == 7){
        if (trueCount >= 3) {
            advice = @"double down";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 16 && dealerCardRank == 9){
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 5) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 13 && dealerCardRank == 2){
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= -1) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 12 && dealerCardRank == 4){
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= 0) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 12 && dealerCardRank == 5){
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= -2) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 12 && dealerCardRank == 6) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= -1) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    } else if (playerScore == 13 && dealerCardRank == 3) {
        if (playerScore - 10 == sumOfRanks){
            advice = @"hit";
        } else if (trueCount >= -2) {
            advice = @"stay";
        } else {
            advice = @"hit";
        }
    }
    
    if ([advice isEqualToString:@"double down"] && [self.blackJackGame.player.hand count] > 2) {
        advice = @"hit";
    }
    
    PlayingCardView *dealerHiddenCard = self.currentCardsView.subviews[0];
    if (dealerHiddenCard.isVisible == NO) {
        [self.notification dismissNotification];
        [self.notification displayNotificationWithMessage:[NSString stringWithFormat:@"The True Count is %ld. You should %@.", (long)trueCount, advice] forDuration:1];
    }
    
    if (self.isAiMode) {
        if ([advice isEqualToString:@"double down"]) {
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doubleDownTapped:) userInfo:nil repeats:NO];
//            [self doubleDownTapped:nil];
        } else if ([advice isEqualToString:@"hit"]) {
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hit:) userInfo:nil repeats:NO];
//            [self hit:nil];
        } else if ([advice isEqualToString:@"stay"]) {
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stay:) userInfo:nil repeats:NO];
//            [self stay:nil];
        }
        if (dealerHiddenCard.isVisible == YES) {
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(deal:) userInfo:nil repeats:NO];
//            [self deal:nil];
        }
    }
    
    
}


#pragma mark - Helper Methods

- (void)layoutGame;
{
    // Background setup
    self.view.backgroundColor = UIColorFromRGB(0x2ecc71);
    
    // Display Deck
    PlayingCardView *deckCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(deckRect.origin.x-6, deckRect.origin.y-6, cardWidth, cardHeight) withRank:@"2" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(deckRect.origin.x-3, deckRect.origin.y-3, cardWidth, cardHeight) withRank:@"3" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard3 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:@"4" withSuit:@"♥" isVisible:NO];
    
    [self.view addSubview:deckCard1];
    [self.view addSubview:deckCard2];
    [self.view addSubview:deckCard3];
    
    UITapGestureRecognizer *singleTapOnDeck = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deal:)];
    singleTapOnDeck.numberOfTapsRequired = 1;
    [deckCard1 addGestureRecognizer:singleTapOnDeck];
    [deckCard2 addGestureRecognizer:singleTapOnDeck];
    [deckCard3 addGestureRecognizer:singleTapOnDeck];
    
    
    // Toolbar setup
    FAKFontAwesome *questionIcon = [FAKFontAwesome questionIconWithSize:30];
    [questionIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImage = [questionIcon imageWithSize:CGSizeMake(30, 30)];
    self.helpBarButton.image = leftImage;
    
    FAKFontAwesome *bulbIcon = [FAKFontAwesome lightbulbOIconWithSize:30];
    [bulbIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *rightImage = [bulbIcon imageWithSize:CGSizeMake(30, 30)];
    self.hintBarButton.image = rightImage;
    
    FAKFontAwesome *chipIcon = [FAKFontAwesome certificateIconWithSize:chipSize];
    [chipIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x45A1CD)];
    self.betLabel = [[UILabel alloc] initWithFrame:betStartRect];
    self.betLabel.attributedText = [chipIcon attributedString];
    [self.view addSubview:self.betLabel];
    [self.view sendSubviewToBack:self.betLabel];
}


- (void)updateLabels
{
    self.score.text = [NSString stringWithFormat:@"%@", self.blackJackGame.player.handScore];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    [self.currentBetLabel setTitle:[NSString stringWithFormat:@"$%@",self.blackJackGame.currentBet] forState:UIControlStateNormal];
    self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue])];
    //                                - [self.blackJackGame.currentBet floatValue])];
    if (self.blackJackGame.player.isBlackjack || self.blackJackGame.dealerPlayer.isBlackjack  || self.blackJackGame.player.isBusted) {
        [self stay:nil];
    }
}

- (PlayingCardView *)drawCard:(PlayingCard *)card withFrame:(CGRect)frame isVisible:(BOOL)isVisible
{
    NSString *playerCardRank = [card formattedCardRank];
    NSString *playerCardSuit = card.suit;
    
    PlayingCardView *playerCardView = [[PlayingCardView alloc] initWithFrame:frame withRank:playerCardRank withSuit:playerCardSuit isVisible:isVisible];
    
    UITapGestureRecognizer *singleTapOnCard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hit:)];
    singleTapOnCard.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *doubleTapOnCard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleDownTapped:)];
    doubleTapOnCard.numberOfTapsRequired = 2;
    
    [singleTapOnCard requireGestureRecognizerToFail:doubleTapOnCard];
    
    [playerCardView addGestureRecognizer:doubleTapOnCard];
    [playerCardView addGestureRecognizer:singleTapOnCard];
    
    [self.currentCardsView addSubview:playerCardView];
    
    return playerCardView;
}

- (void)animatePlayingCardView:(PlayingCardView *)cardView withFlip:(BOOL)toFlip withDelay:(NSTimeInterval)toDelay withTilt:(BOOL)toTilt toFrame:(CGRect)frame onCompletion:(void (^) (void))handler
{
    [UIView animateWithDuration:0.3 delay:toDelay options:UIViewAnimationOptionTransitionNone animations:^{
        if (self.blackJackGame.isDoubleDown == YES && frame.origin.y > playerRect.origin.y) {
            cardView.frame = CGRectMake(frame.origin.x-20,frame.origin.y+30, frame.size.width, frame.size.height);
        } else {
            cardView.frame = frame;
        }
        
    } completion:^(BOOL finished){
        if (toTilt) {
            if (self.blackJackGame.isDoubleDown == YES && frame.origin.y > playerRect.origin.y) {
                [cardView tiltCardWithDegrees:90];
            } else {
                [cardView tiltCardRandomly];
            }
        }
        if (toFlip) [cardView flipCard];
        if (finished && handler) {
            handler();
        }
    }];
}

- (void)animatePlayingCardView:(PlayingCardView *)cardView withFlip:(BOOL)toFlip withTilt:(BOOL)toTilt toFrame:(CGRect)frame onCompletion:(void (^) (void))handler
{
    [self animatePlayingCardView:cardView withFlip:toFlip withDelay:0 withTilt:toTilt toFrame:frame onCompletion:handler];
}

- (void)animatebetLabel:(UILabel *)label toFrame:(CGRect)frame onCompletion:(void (^) (void))handler
{
    [UIView animateWithDuration:0.3 animations:^{
        label.frame = frame;
    } completion:^(BOOL finished){
        if (finished && handler) {
            handler();
        }
    }];
}

- (void)updateBet:(NSString *)betString
{
    [self.currentBetLabel setTitle:[NSString stringWithFormat:@"$%@",betString] forState:UIControlStateNormal];
    
    self.blackJackGame.currentBet = @([betString integerValue]);
}

- (void)dealCards
{
    [self.notification dismissNotification];
    
    if ([self.blackJackGame.playingCardDeck.cards count] < 20) {
        CGFloat chipCount = [self.blackJackGame.chips floatValue];
        self.blackJackGame = [FISBlackJackGame new];
        self.blackJackGame.chips = @(chipCount);
        [self.notification displayNotificationWithMessage:@"Shuffling" forDuration:1];
    }
    
    [self.blackJackGame deal];
    
    // Remove cards from previous hand from view
    for (PlayingCardView *card in self.currentCardsView.subviews) {
        [card removeFromSuperview];
    }
    
    [self.betLabel setFrame:betStartRect];
    [self.ddLabel removeFromSuperview];
    self.score.text = @"";
    self.dealerScore.text = @"";
    self.dealerScore.hidden = YES;
    self.score.hidden = YES;
    
    // Draw new hand
    PlayingCardView *dealerCardView1 = [self drawCard:self.blackJackGame.dealerPlayer.hand[0] withFrame:deckRect isVisible:NO];
    PlayingCardView *dealerCardView2 = [self drawCard:self.blackJackGame.dealerPlayer.hand[1] withFrame:deckRect isVisible:NO];
    
    PlayingCardView *playerCardView1 = [self drawCard:self.blackJackGame.player.hand[0] withFrame:deckRect isVisible:NO];
    PlayingCardView *playerCardView2 = [self drawCard:self.blackJackGame.player.hand[1] withFrame:deckRect isVisible:NO];
    
    [self animatebetLabel:self.betLabel toFrame:betEndRect onCompletion:^(void) {
        [self animatePlayingCardView:playerCardView1 withFlip:YES withTilt:YES toFrame:playerRect onCompletion:^(void) {
            [self animatePlayingCardView:dealerCardView1 withFlip:NO withTilt:NO toFrame:dealerRect onCompletion:^(void) {
                [self animatePlayingCardView:playerCardView2 withFlip:YES withTilt:YES toFrame:CGRectMake(playerRect.origin.x+30, playerRect.origin.y+10, cardWidth, cardHeight) onCompletion:^(void) {
                    [self animatePlayingCardView:dealerCardView2 withFlip:YES withTilt:YES toFrame:CGRectMake(dealerRect.origin.x+30, dealerRect.origin.y+10, cardWidth, cardHeight) onCompletion:^(void){
                        [self updateLabels];
                        self.score.hidden = NO;
                        [self hintTapped:nil];
                    }];
                }];
            }];
        }];
    }];
}

- (void)showGameOverAlert
{
    [self.notification dismissNotification];
    [self.notification displayNotificationWithMessage:@"AI MODE OFF" completion:nil];
    self.isAiMode = NO;
    UIAlertView *gameOver = [[UIAlertView alloc]initWithTitle:@"Do you want to start over?"
                                                      message:@"Click OK to hit the ATM and reshuffle."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    gameOver.tag = 2;
    [gameOver show];
}

@end
