//
//  MessagesMasterViewController.m
//  Messages
//
//  Created by Adi Dahiya on 11/11/2012.
//  Copyright (c) 2012 Adi Dahiya. All rights reserved.
//

#import "MessagesMasterViewController.h"

#import "MessagesDetailViewController.h"

@interface MessagesMasterViewController () {
    NSMutableArray *_objects;   // Contains NSDictionaries for messages
    NSMutableData *_data;
}
@end

@implementation MessagesMasterViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) loadMessages
{
    // GET data from the messages API
    NSString *messagesURL = @"http://cis195-messages.herokuapp.com/messages";
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:messagesURL]];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    [connection start];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //  self.navigationItem.rightBarButtonItem = addButton;
    // [self.messageButton setTarget:self];
    // [self.messageButton setAction:@selector(insertNewObject:)];

    [self loadMessages];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                       forIndexPath:indexPath];

    NSMutableDictionary *msg  = _objects[indexPath.row];
    cell.textLabel.text       = (NSString *) [msg objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString *) [msg objectForKey:@"created_at"];
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView
  canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
        // array, and add a new row to the table view.
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"newMessage"]) {
        if (!_objects) {
            _objects = [[NSMutableArray alloc] init];
        }
        
        NSArray *values = [NSArray arrayWithObjects:@"New Message",
                           @"Write your message...", @"true", nil];
        NSArray *keys = [NSArray arrayWithObjects:@"title", @"body", @"is_new", nil];
        NSMutableDictionary *newMessage = [NSMutableDictionary
                                           dictionaryWithObjects:values
                                           forKeys:keys];
        
        [_objects insertObject:newMessage atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [[segue destinationViewController] setDetailItem:newMessage];
    }
}

#pragma mark - Connection callbacks

- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSDate *createdAt;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSArray *messages = [NSJSONSerialization JSONObjectWithData:_data options:0
                                                          error:nil];
    NSMutableDictionary *messageObject;
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary *message in messages) {
        messageObject = [NSMutableDictionary dictionaryWithDictionary:message];
        
        if ([messageObject valueForKey:@"title"] == (id)[NSNull null] ||
            [messageObject valueForKey:@"body"]  == (id)[NSNull null]) {
            continue;
        }
        
        createdAt = [inputFormatter
                     dateFromString:[message valueForKey:@"created_at"]];
        [messageObject setValue:[outputFormatter stringFromDate:createdAt]
                         forKey:@"created_at"];
        [_objects addObject:messageObject];
    }
    
    NSLog(@"**************");
    [connection cancel];
    [self.tableView reloadData];
}


- (IBAction) refreshMessages:(UIBarButtonItem *)sender
{
    _data = nil;
    _objects = nil;
    [self loadMessages];
}
@end
