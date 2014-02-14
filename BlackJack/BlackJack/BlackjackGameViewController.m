//
//  BlackjackGameViewController.m
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "BlackjackGameViewController.h"

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
    if([self.blackJackGame.hand count] > 2) {
        self.card3.text = [self.blackJackGame.hand[2] description];
        self.card3.hidden = NO;

    }
    if([self.blackJackGame.hand count] > 3) {
        self.card4.text = [self.blackJackGame.hand[3] description];
        self.card4.hidden = NO;
    }
    if([self.blackJackGame.hand count] > 4) {
        self.card5.text = [self.blackJackGame.hand[4] description];
        self.card5.hidden = NO;
    }
}

- (IBAction)deal:(id)sender {
    self.card3.hidden = YES;
    self.card4.hidden = YES;
    self.card5.hidden = YES;
    
    NSLog(@"Deal was tapped");
    self.blackJackGame = [[FISBlackJackGame alloc] init];
    [self.blackJackGame deal];
    self.card1.text = [self.blackJackGame.hand[0] description];
    self.card2.text = [self.blackJackGame.hand[1] description];
    self.card1.hidden = NO;
    self.card2.hidden = NO;
}
@end
