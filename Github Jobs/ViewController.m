//
//  ViewController.m
//  Github Jobs
//
//  Created by Mia on 10/24/16.
//  Copyright © 2016 WondersGroupXLab. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *jobs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSString *endpoint = [[NSBundle bundleForClass:[self class]] infoDictionary][@"GithubJobsEndpoint"];
//    NSURL *url = [NSURL URLWithString:[endpoint stringByAppendingString:@"?description=ios&location=sanfrancisco"]];
//#if DEBUG
//    NSURL *url = [NSURL URLWithString:@"https://127.0.0.1:9000/positions.json?description=ios&location=sanfrancisco"];
//#else
    NSURL *url = [NSURL URLWithString:@"https://jobs.github.com/positions.json?description=ios&location=sanfrancisco"];
//#endif
    NSURLSessionDataTask *jobTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"An error occured" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            NSError *jsonError = nil;
            self.jobs = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%lu jobs fetched", (unsigned long)[self.jobs count]]];
        });
    }];
    
    [SVProgressHUD showWithStatus:@"Fetching jobs..."];
    [jobTask resume];
    

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = self.jobs[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *jobUrl = [NSURL URLWithString:self.jobs[indexPath.row][@"url"]];
    [[UIApplication sharedApplication] openURL:jobUrl];// options:@{} completionHandler:^(BOOL success) {
        
//    }];
}

@end
