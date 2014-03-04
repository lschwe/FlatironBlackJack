//
//  HelpViewViewController.m
//  
//
//  Created by Dare Ryan on 3/3/14.
//
//

#import "HelpViewViewController.h"

@interface HelpViewViewController ()
- (IBAction)exitButtonIsPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *cardPointerLabel;
@property (strong, nonatomic) IBOutlet UILabel *betPointerLabel;
@property (strong, nonatomic) IBOutlet UILabel *holdSwipeLabel;
@property (strong, nonatomic) IBOutlet UILabel *deckPointerLabel;

@end

@implementation HelpViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.cardPointerLabel.attributedText = [[FAKFontAwesome handOLeftIconWithSize:30]attributedString];
    
    
    self.betPointerLabel.attributedText = [[FAKFontAwesome handOUpIconWithSize:30]attributedString];
    
    self.holdSwipeLabel.attributedText = [[FAKFontAwesome arrowsHIconWithSize:40]attributedString];
    
    self.deckPointerLabel.attributedText = [[FAKFontAwesome handORightIconWithSize:30]attributedString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButtonIsPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
