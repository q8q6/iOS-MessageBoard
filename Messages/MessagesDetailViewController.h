//
//  MessagesDetailViewController.h
//  Messages
//
//  Created by Adi Dahiya on 11/11/2012.
//  Copyright (c) 2012 Adi Dahiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;

@end
