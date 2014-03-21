//
//  SMListViewController.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMListViewController.h"
#import "SMAppDelegate.h"
#import "SMQuickObjectMapper.h"
#import "SMMovieTableViewCell.h"
#import <CoreData+MagicalRecord.h>

@interface SMListViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) NSArray* dataSource;
- (IBAction)clearCache:(id)sender;
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
    
    if (self.useCache) {
        self.dataSource = [SMAppStoreModel MR_findAll];
        [self.tableView reloadData];
        
    }
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.useCache == NO){
        self.dataSource = nil;
        self.searchBar.text = @"";
        self.title = @"Search a title!";
        [self.tableView reloadData];
    }
}
- (void) searchMovieWithTitle:(NSString*) title {
    if (title == nil) return;
    NSDictionary* parameters= @{@"term":title,@"entity":@"movie",@"country":@"us",@"media":@"movie",@"attribute":@"movieTerm"};
    [self setTitle:@"Loading..."];
    __weak SMListViewController* wSelf = self;
    [[SMQuickObjectMapper objectManagerWithBaseurl:BASEURL] getObjectsAtPath:SEARCH_PATH parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        wSelf.dataSource = [mappingResult array];
        

        if (wSelf.dataSource.count && [wSelf.dataSource[0] isKindOfClass:[SMAppStoreResponse class]]) {
            wSelf.dataSource = [wSelf.dataSource[0] movies];
        }
        [wSelf.tableView reloadData];
        if (wSelf.dataSource.count>0){
            wSelf.title = [NSString stringWithFormat:@"Movies with \"%@\"",title];
        }
        else {
            wSelf.title = @"No movies found";
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Mapping operation failed!");
        wSelf.title = @"Mapping failed!";
    }];
    
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchMovieWithTitle:searchBar.text];
    [searchBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (void) setupCell:(SMMovieTableViewCell*) cell fromIndexPath:(NSIndexPath*) indexPath {
    SMAppStoreModel* model = self.dataSource[indexPath.row];
    cell.lbl_title.text = model.name;
    cell.lbl_genre.text = model.genre;
    [cell.img_poster setImageWithURL:[NSURL URLWithString:model.artworkUrl] placeholderImage:[UIImage imageNamed:@"apple"]];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMovieTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self setupCell:cell fromIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMovieTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self setupCell:cell fromIndexPath:indexPath];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction) returnToHome:(UIStoryboardSegue*) segue {;}
- (IBAction)clearCache:(id)sender {
    [SMAppStoreModel MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
