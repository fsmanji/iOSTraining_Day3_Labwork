//
//  ChatViewController.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "Utility.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UILabel *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
@property NSArray* messageList;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //add a PTR control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    //load previous messages
    [self retrieveMessages];
}

-(void)onRefresh {
    [self retrieveMessages];
}


- (IBAction)onSend:(id)sender {
    PFObject* message = [PFObject objectWithClassName:kMessageClassName];
    message[kMessageTextPropertyName] = self.textInput.text;
            
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Message sent: %@", message[kMessageTextPropertyName]);
        } else {
            // There was a problem, check error.description
            NSString *errorString = [error userInfo][@"error"];
            [Utility showAlert:self with:@"Send Message Failed" withMessage:errorString];
        }
    }];
}

- (void) retrieveMessages {
    PFQuery *query = [PFQuery queryWithClassName:kMessageClassName];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageList = objects;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %li scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[kMessageTextPropertyName]);
            }
        } else {
            // Log details of the failure
            [Utility showAlert:self with:@"Get Message Failed" withMessage:error.description];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    NSInteger row = indexPath.row;
    PFObject* object = _messageList[row];
    cell.textLabel.text = object[kMessageTextPropertyName];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
