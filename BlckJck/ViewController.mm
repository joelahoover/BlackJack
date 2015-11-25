//
//  ViewController.m
//  BlckJck
//
//  Test comment
//  Kyle- 2015
//
//  Created by Joel Hoover on 11/20/15.
//  Copyright (c) 2015 joelhoover. All rights reserved.
//

#import "ViewController.hh"
#import "Card.h"
#import "DeckOfCards.h"
#import "Hand.h"

@interface ViewController () {
    DeckOfCards deck;
    Hand playerHand;
    Hand dealerHand;
    
    NSArray *nameArray;
}
@property (weak, nonatomic) IBOutlet UILabel *currentHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourHandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardBack;
@property (weak, nonatomic) IBOutlet UIImageView *cardFront;
@property (weak, nonatomic) IBOutlet UIImageView *duckWing;
@property (weak, nonatomic) IBOutlet UIImageView *winLoseImage;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;



@end

@implementation ViewController

//I cannot for the life of me seem to get the completion blocks working, so if anyone knows how to do that let me know (kyle)
- (IBAction)hitMeButton:(id)sender {
    
    //Declaring a variable to hold the top card.
    Card topCard = deck.dealCard();
    playerHand.Hit(topCard);
    
    
    //Defining the location for the frontImage view to appear.
    CGRect cardFrontLoc = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 80, 100, 160);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:cardFrontLoc];
    
    
    //Trying to fix the start point of the backFrame.
    self.cardBack.frame = CGRectMake(138, 204, 25, 40);
   
//    _currentHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    
    //Array for testing. Will eventually be 52 strings long representing all of the images.
    nameArray = @[@"AceFox", @"KingElephant", @"QueenMonkey", @"FiveGiraffe"];
    
    //Disable additional button input while animation is running.
    self.hitButton.enabled = false;
    self.holdButton.enabled = false;
    
    //Rotate the duck flipper and move the card.
    [UIView animateWithDuration:1.1f
                          delay:0.0f
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         //Rotates wing then places the top card in the middle of the screen
                         self.duckWing.transform = CGAffineTransformMakeRotation(M_PI/-2);
                         self.cardBack.center  = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
                         
                     }
                     completion:^(BOOL finished) {
                         //Return the duck wing to the original location and resize the back of the card view
                         [UIView animateWithDuration:1.5f
                                          animations:^{
                                              
                                              self.duckWing.transform = CGAffineTransformIdentity;
                                              self.cardBack.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 80, 100, 160);
                                            
                                              
                                          }
                          completion:^(BOOL finished) {
                              //When the above is done reveal the front of the card. (The correct card image to load still needs to be done)
                              
                              //This will be replaced with a call to the array based on a parameter unique to each card. For now it just assigns an image based on the suit.
                              [self.view addSubview:iv];
                              
                              if (topCard.suit == 1) {
                                  iv.image = [UIImage imageNamed:@"AceFox"];
                              }
                              else if (topCard.suit == 2) {
                                  
                                  iv.Image = [UIImage imageNamed:@"QueenMonkey"];
                              }
                              
                              else if (topCard.suit == 3) {
                                  iv.image = [UIImage imageNamed:@"FiveGiraffe"];
                              }
                              else
                                iv.image = [UIImage imageNamed:@"KingElephant"];
                              
                              
                              //Old way it worked. Just left it so if I need to go back to it.
                          
//                              self.cardFront.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 80, 100, 160);
//                              self.cardFront.alpha = 1;
                              
                              //Rerturning the cardBack view to the top of the deck.
                              self.cardBack.frame = CGRectMake(138, 204, 25, 40);
                              
                              [UIView animateWithDuration:1.0
                                                    delay:0.6
                                                  options:UIViewAnimationCurveEaseOut
                                               animations:^{
                                  //Move the dealt card to your hand.
//                                  self.cardFront.frame = CGRectMake(25, 553, 50, 80);
                                                   
                                                   //Determines where each card should be put based on hand size.
                                                   unsigned long numCards = playerHand.myHand.size();
                                                   iv.frame = CGRectMake(25 + 60*(numCards -1) , 553, 50, 80);
                                  
                              }
                               completion:^(BOOL finished) {
                                   
                                   //Updates the text that displays your hand score
                               _yourHandLabel.text = [@"Your Hand: " stringByAppendingString:[NSString stringWithFormat:@"%i", playerHand.getTotal()]];
                                   
                                   
                                   self.hitButton.enabled = true; //Allow further input
                                   self.holdButton.enabled = true;
                               }];
                              
                          }];
                          }
     
     ];
    
}

- (IBAction)holdButton:(id)sender {
    //_totalHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    //_totalHandLabel.text = [NSString stringWithFormat:@"%d", playerHand.getTotal() ];
    
    //Display a visual for whether you won (this should probably be a helper function. Not sure how to do that in Objective-C though.
    UIImage *image;
    if (playerHand.getTotal() > dealerHand.getTotal()) {
        image = [UIImage imageNamed:@"WinDuck"];
        
    }
    else if (playerHand.getTotal() < dealerHand.getTotal()) {
        image = [UIImage imageNamed:@"LoseDuck"];
    }
    else {
        image = [UIImage imageNamed:@"TieImage"];
    }
    
    //Assigning the correct image to the view that shows the result, then brings it to the front and animates its resizing.
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.winLoseImage setImage:image]; //Assigning the correct image to the view
                         [self.view bringSubviewToFront:self.winLoseImage];
                         self.winLoseImage.transform = CGAffineTransformMakeScale(1.25, 1.25); //Animated size increase
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.0f
                                               delay:3.0f
                                             options:UIViewAnimationCurveEaseOut
                                          animations:^{
                                          }
                                          completion:^(BOOL finished) {
                                                [self.view sendSubviewToBack:self.winLoseImage];
                                          }];
                     }
     ];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    deck.shuffle();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
