//
//  SMListViewController.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMListViewController.h"
#import "NSObject+SMQuickDownload.h"
#import "SMAppDelegate.h"

@interface SMListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray* dataSource;
@end

@implementation SMListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
// https://itunes.apple.com/search?term=star&entity=movie&country=us&media=movie&attribute=movieTerm
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"STAR";
    [self downloadDataWithObjectRequest:[SMObjectRequest objectRequestWithBaseurl:BASEURL path:SEARCH_PATH parameters:@{@"term":@"star",@"entity":@"movie",@"country":@"us",@"media":@"movie",@"attribute":@"movieTerm"} method:SM_GET]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadDidCompleteWithMappingResults:(NSArray *)mappingResults objectRequest:(SMObjectRequest *)objectRequest {
    if ([objectRequest.path isEqualToString:SEARCH_PATH]){
        self.dataSource = mappingResults;
        [self.tableView reloadData];
    }
}
- (void)downloadDidFailWithError:(NSError *)error objectRequest:(SMObjectRequest *)objectRequest {
    ;
}

- (void)showLoadingView {
    self.title = @"loading...";
}

- (void) hideLoadingView {
    self.title = @"STAR";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SMAppStoreModel* model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}


@end
