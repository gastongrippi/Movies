//
//  listOfMoviesViewController.m
//  Movies
//
//  Created by gaston on 11/24/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "listOfMoviesViewController.h"
#import "MovieTableViewCell.h"
#import "moviesAPIConstants.h"
#import "movieData.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"

static NSString *CellIdentifier = @"MovieCell";

@interface listOfMoviesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *screenTitle;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *topRatedMovies;
@property (strong, nonatomic) movieData *movieData;


@end

@implementation listOfMoviesViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self addScreenTitle];
    [self cofigureTableview];
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
    return [_movieData.moviesResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.movieTitle.text = [[_movieData.moviesResults objectAtIndex:[indexPath row]] objectForKey:kTitleKey];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kMoviesBaseImageURL, [[_movieData.moviesResults objectAtIndex:[indexPath row]] objectForKey:kBackdropPathKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak MovieTableViewCell *weakCell = cell;
    
    [cell.movieBackgroundImage setImageWithURLRequest:request
                          placeholderImage:loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.movieBackgroundImage.image = [self convertImageToGrayScale:image];
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kMoviesBaseImageURL, [[[self.topRatedMovies objectForKey:kResultsKey] objectAtIndex:[indexPath row]] objectForKey:kBackdropPathKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    UIImageView *currentImage = [[UIImageView alloc] init];
    
     __weak UIImageView *weakCurrentImage = currentImage;
    
    [currentImage setImageWithURLRequest:request
    placeholderImage:loading
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCurrentImage.image = image;
    } failure:nil];
    
    CGFloat imageRatio = [self getCropRatioOfImage:currentImage.image];
    
    return (tableView.frame.size.width / imageRatio);
}

#pragma mark - private methods

- (void)loadData {
    // 1
    NSString *string = [NSString stringWithFormat:@"%@%@", kMoviesBaseURLString,kMoviesAPIKey];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    // 2
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@",(NSDictionary *)responseObject);
        _topRatedMovies = responseObject;
        _movieData = [[movieData alloc] initWithData:[self.topRatedMovies objectForKey:kResultsKey]];
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

- (void)cofigureTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenTitle.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.greaterThanOrEqualTo(self.view.mas_bottom);
    }];
}

- (void)addScreenTitle {
    _screenTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    _screenTitle.text = @"top rated movies";
    [_screenTitle setFont:[UIFont fontWithName:@"Helvetica" size:30]];
    [_screenTitle setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:_screenTitle];
    
    [_screenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.lessThanOrEqualTo(@100);
    }];
}

- (CGFloat)getCropRatioOfImage:(UIImage *)image {
    return (image.size.width / image.size.height);
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

@end


