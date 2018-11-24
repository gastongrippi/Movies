//
//  listOfMoviesViewController.m
//  Movies
//
//  Created by gaston on 11/24/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "listOfMoviesViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"

static NSString * const BaseURLString = @"https://api.themoviedb.org/3/movie/top_rated?api_key=";
static NSString * const apiKey = @"208ca80d1e219453796a7f9792d16776";
static NSString * const baseImageURL = @"https://image.tmdb.org/t/p/w200";

@interface listOfMoviesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *screenTitle;
@property (strong,nonatomic) UITableView *tableView;
@property (strong) NSDictionary *topRatedMovies;

@end

@implementation listOfMoviesViewController


- (void)cofigureTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MovieCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenTitle.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.greaterThanOrEqualTo(self.view.mas_bottom);
    }];
}

- (void)addScreenTitle {
    _screenTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_screenTitle];
    [_screenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(20));
    }];
    [_screenTitle setTextAlignment:NSTextAlignmentCenter];
    _screenTitle.text = @"top rated movies";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self addScreenTitle];
    [self cofigureTableview];
    // 1
    NSString *string = [NSString stringWithFormat:@"%@%@", BaseURLString,apiKey];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    // 2
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", _topRatedMovies = (NSDictionary *)responseObject);
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
        [alert addAction:defaultAction];
        NSLog(@"Error: %@", error);
        return;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.topRatedMovies objectForKey:@"results"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MovieCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [[[self.topRatedMovies objectForKey:@"results"] objectAtIndex:[indexPath row]] objectForKey:@"title"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",baseImageURL, [[[self.topRatedMovies objectForKey:@"results"] objectAtIndex:[indexPath row]] objectForKey:@"backdrop_path"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
