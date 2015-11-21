//
//  ViewController.m
//  BlckJck
//
//  Test comment
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
}
@property (weak, nonatomic) IBOutlet UILabel *currentHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardBack;
@property (weak, nonatomic) IBOutlet UIImageView *cardFront;
@property (weak, nonatomic) IBOutlet UIImageView *duckWing;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;
@property (weak, nonatomic) IBOutlet UIImageView *winLoseImage;


@end

@implementation ViewController

//I cannot for the life of me seem to get the completion blocks working, so if anyone knows how to do that let me know (kyle)
- (IBAction)hitMeButton:(id)sender {
    playerHand.Hit(deck.dealCard());
//    _currentHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    
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
                              //When the above is done reveral the front of the card. (The correct card image to load still needs to be done)
                              
                              self.cardFront.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 80, 100, 160);
                              self.cardFront.alpha = 1;
                              
                              //Rerturning the cardBack view to the top of the deck.
                              self.cardBack.frame = CGRectMake(138, 229, 25, 40);
                              
                              [UIView animateWithDuration:1.0 animations:^{
                                  //Move the dealt card to your hand.
                                  self.cardFront.frame = CGRectMake(25, 553, 50, 80);
                                  
                              }
                               completion:^(BOOL finished) {
                                   self.hitButton.enabled = true; //Allow further input
                                   self.holdButton.enabled = true;
                               }];
                              
                          }];
                          }
     
     ];
    
}

- (IBAction)holdButton:(id)sender {
    //_totalHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    _totalHandLabel.text = [NSString stringWithFormat:@"%d", playerHand.getTotal() ];
    
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
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.winLoseImage setImage:image]; //Assigning the correct image to the view
                         [self.view bringSubviewToFront:self.winLoseImage];
                         self.winLoseImage.transform = CGAffineTransformMakeScale(1.25, 1.25); //Animated size increase
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:5.0
                                               delay:0.0
                                             options:UIViewAnimationCurveEaseOut
                                          animations:^{
                                              [self.view sendSubviewToBack:self.winLoseImage];
                                          }
                                          completion:nil];
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
