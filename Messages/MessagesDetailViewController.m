//
//  MessagesDetailViewController.m
//  Messages
//
//  Created by Adi Dahiya on 11/11/2012.
//  Copyright (c) 2012 Adi Dahiya. All rights reserved.
//

#import "MessagesDetailViewController.h"

@interface MessagesDetailViewController ()
- (void)configureView;
@end

@implementation MessagesDetailViewController

#pragma mark - Managing the detail item

- (void) setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        NSLog(@"%@", newDetailItem);
        // Update the view.
        [self configureView];
    }
}

- (void) configureView
{
    // Update the user interface for the detail item.
    NSDictionary *msg = self.detailItem;

    if (msg) {
        self.detailDescriptionLabel.text = [msg description];
        self.titleLabel.text = (NSString *) [msg objectForKey:@"title"];
        self.bodyLabel.text = (NSString *) [msg objectForKey:@"body"];
        self.dateLabel.text = (NSString *) [msg objectForKey:@"created_at"];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
