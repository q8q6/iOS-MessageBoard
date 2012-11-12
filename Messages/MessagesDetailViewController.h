//
//  MessagesDetailViewController.h
//  Messages
//
//  Created by Adi Dahiya on 11/11/2012.
//  Copyright (c) 2012 Adi Dahiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesDetailViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postMessageButton;

- (IBAction)postMessage:(UIBarButtonItem *)sender;

@end
