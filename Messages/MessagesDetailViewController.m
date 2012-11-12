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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *createdAt;
    
    // Update the user interface for the detail item.
    NSMutableDictionary *msg = self.detailItem;

    if (msg) {
        if ([msg objectForKey:@"is_new"]) {
            createdAt = [formatter stringFromDate:[NSDate date]];
            [msg setValue:createdAt forKey:@"created_at"];
            [self.postMessageButton setStyle:UIBarButtonItemStyleDone];
            [self.navigationController.navigationItem.backBarButtonItem
             setEnabled:FALSE];
        } else {
            // Only show 'Post message' button if is_new
            [self.postMessageButton setEnabled:FALSE];
            [self.titleLabel setEnabled:FALSE];
            [self.bodyLabel setEditable:FALSE];
        }

        self.titleLabel.text = (NSString *) [msg objectForKey:@"title"];
        self.bodyLabel.text  = (NSString *) [msg objectForKey:@"body"];
        self.dateLabel.text  = (NSString *) [msg objectForKey:@"created_at"];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void) viewDidDisappear:(BOOL)animated
{
    if ([self.detailItem valueForKey:@"is_new"]) {
        
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) postMessage:(UIBarButtonItem *)sender
{
    NSString *title = self.titleLabel.text;
    NSString *body = self.bodyLabel.text;
    
    NSString *url = @"http://cis195-messages.herokuapp.com/messages";
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *data = [NSString
                      stringWithFormat:@"message[title]=%@&message[body]=%@",
                      title, body];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    [connection start];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    // Can't post anymore after message is sent
    [self.postMessageButton setEnabled:FALSE];
    [self.detailItem setValue:nil forKey:@"is_new"];
}

@end
