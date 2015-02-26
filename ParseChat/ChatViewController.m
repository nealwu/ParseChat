//
//  ChatViewController.m
//  ParseChat
//
//  Created by Neal Wu on 2/26/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];

    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self onTimer];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    cell.chatLabel.text = self.chats[indexPath.row];
    return cell;
}

- (IBAction)onSend:(id)sender {
    PFObject *chat = [PFObject objectWithClassName:@"Message"];
    chat[@"text"] = self.textField.text;
    self.textField.text = @"";

    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Save succeeded: %@", self.textField.text);
        } else {
            NSLog(@"Save failed: %@", error);
        }
    }];
}

- (void)onTimer {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %ld scores.", objects.count);
            self.chats = [NSMutableArray array];

            for (PFObject *object in objects) {
                NSLog(@"WOO");
                NSLog(@"%@", object);

                if ([object objectForKey:@"text"] != nil) {
                    [self.chats addObject:object[@"text"]];
                }
            }

            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
