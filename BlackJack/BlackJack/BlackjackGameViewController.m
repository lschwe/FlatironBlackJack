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
//    self.notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    self.notification.notificationLabelBackgroundColor = UIColorFromRGB(0x45A1CD);
    
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
        UIAlertView *shakeAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to change tables?" message:@"Click OK to quit the current game and deal fresh decks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [shakeAlert show];
        
        
    }
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex){
        
    }else{
        [self.blackJackGame.playingCardDeck.cards removeAllObjects];
        [self deal:nil];
    }
}

#pragma mark - IBActions

- (IBAction)betButtonTapped:(UIButton *)sender
{
    NSArray *betOptions = @[@"5",@"10",@"15",@"20",@"25",@"50",@"75",@"100"];

    self.betPicker = [[CEPopupPickerView alloc] initWithValues:betOptions callback:^(NSInteger selectedIndex) {
        [self updateBet:[betOptions objectAtIndex:selectedIndex]];
    }];
    
    [self.betPicker presentInView:self.view];
    
}

- (IBAction)doubleDownTapped:(id)sender {
    PlayingCardView *dealerHiddenCard = [self.currentCardsView subviews][0];
    if (!self.blackJackGame.player.isBusted && !dealerHiddenCard.isVisible) {
        self.blackJackGame.isDoubleDown = YES;
        NSLog(@"Double Down");
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
    NSLog(@"Hit was tapped");
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
        [self animatePlayingCardView:playerCardView withFlip:YES withTilt:YES toFrame:CGRectMake(lastCardX+30, lastCardY+10, cardWidth, cardHeight) onCompletion:nil];
        
        [self updateLabels];
    }
}

- (IBAction)deal:(id)sender {
    
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
    
    // Draw new hand
    PlayingCardView *dealerCardView1 = [self drawCard:self.blackJackGame.dealerPlayer.hand[0] withFrame:deckRect isVisible:NO];
    PlayingCardView *dealerCardView2 = [self drawCard:self.blackJackGame.dealerPlayer.hand[1] withFrame:deckRect isVisible:NO];
    
    PlayingCardView *playerCardView1 = [self drawCard:self.blackJackGame.player.hand[0] withFrame:deckRect isVisible:NO];
    PlayingCardView *playerCardView2 = [self drawCard:self.blackJackGame.player.hand[1] withFrame:deckRect isVisible:NO];
    
    

    
    [self animatebetLabel:self.betLabel toFrame:betEndRect onCompletion:^(void) {
        [self animatePlayingCardView:playerCardView1 withFlip:YES withTilt:YES toFrame:playerRect onCompletion:^(void) {
            [self animatePlayingCardView:dealerCardView1 withFlip:NO withTilt:NO toFrame:dealerRect onCompletion:^(void) {
                [self animatePlayingCardView:playerCardView2 withFlip:YES withTilt:YES toFrame:CGRectMake(playerRect.origin.x+30, playerRect.origin.y+10, cardWidth, cardHeight) onCompletion:^(void) {
                    [self animatePlayingCardView:dealerCardView2 withFlip:YES withTilt:YES toFrame:CGRectMake(dealerRect.origin.x+30, dealerRect.origin.y+10, cardWidth, cardHeight) onCompletion:nil];
                }];
            }];
        }];
    }];
    
    [self updateLabels];
    
}

- (IBAction)stay:(id)sender {
    
    PlayingCardView *dealerHiddenCard = self.currentCardsView.subviews[0];
    
    if (dealerHiddenCard.isVisible == NO) {
        
        [self.blackJackGame stay];
        [dealerHiddenCard flipCard];
        
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
            if (self.blackJackGame.isDoubleDown) {
                multiple = 2;
            }
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] + [self.blackJackGame.currentBet floatValue]*multiple);
//            NSLog(@"Player has won %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
        } else if ([winner isEqualToString:@"Dealer"]){
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue]);
//            NSLog(@"Player has lost %@ chips. Now he has %@", self.blackJackGame.currentBet, self.blackJackGame.chips);
        } else {
//            NSLog(@"Push. Player keeps his %@ chips", self.blackJackGame.chips);
        }
        
        self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
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
    FAKFontAwesome *questionIcon = [FAKFontAwesome questionIconWithSize:20];
    [questionIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImage = [questionIcon imageWithSize:CGSizeMake(20, 20)];
    self.helpBarButton.image = leftImage;
    
    FAKFontAwesome *bulbIcon = [FAKFontAwesome lightbulbOIconWithSize:20];
    [bulbIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *rightImage = [bulbIcon imageWithSize:CGSizeMake(20, 20)];
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
    self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
    if (self.blackJackGame.player.isBlackjack || self.blackJackGame.player.isBusted) {
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

- (void)animatePlayingCardView:(PlayingCardView *)cardView withFlip:(BOOL)toFlip withTilt:(BOOL)toTilt toFrame:(CGRect)frame onCompletion:(void (^) (void))handler
{
    [UIView animateWithDuration:0.3 animations:^{
        cardView.frame = frame;
    } completion:^(BOOL finished){
        if (toFlip) [cardView flipCard];
        if (toTilt) [cardView tiltCardRandomly];
        if (finished && handler) {
            handler();
        }
    }];
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




@end
