//
//  MovieDescriptionViewController.m
//  Movies
//
//  Created by gaston on 11/26/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "MovieDescriptionViewController.h"
#import "MoviesAPIConstants.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>

@interface MovieDescriptionViewController ()

@property(strong, nonatomic)UINavigationBar *navBar;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIView *contentView;

@property(strong, nonatomic)UIImageView *movieBackgroundImageView;
@property(strong, nonatomic)UIImageView *moviePosterImageView;
@property(strong, nonatomic)UILabel *movieDescription;
@property(strong, nonatomic)UIView *translucentView;

@property(strong, nonatomic)NSString *movieOverview;
@property(strong, nonatomic)NSString *backdropURL;
@property(strong, nonatomic)NSString *posterURL;

@end

@implementation MovieDescriptionViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialView];
    [self initializeDescriptionLabel];
    [self initializeBackdropImage];
    [self initializeTranslucentView];
    [self initializePosterImage];
    
    [self applyInitialViewConstraints];
    [self applyBackdropImageConstraints];
    [self applyTranslucentViewConstraints];
    [self applyPosterImageConstraints];
    [self applyDescriptionLabelConstraints];
}

- (instancetype)initWitData:(MovieData *)data {
    self = [super init];
    if (self) {
        _movieOverview = data.movieDescription;
        _backdropURL = data.backDropImageURL;
        _posterURL = data.posterPathImageURL;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)navigateBack {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupInitialView {
    self.view = [[UIView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    _contentView = [[UIView alloc] init];
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    _navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Movie detail";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(navigateBack)];
    navItem.leftBarButtonItem = leftButton;
    _navBar.items = @[navItem];
}


- (void)initializeTranslucentView {
    _translucentView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)initializeDescriptionLabel {
    _movieDescription = [[UILabel alloc]initWithFrame:CGRectZero];
    _movieDescription.numberOfLines = 0;
    [_movieDescription setTextAlignment:NSTextAlignmentJustified];
    [_movieDescription setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    _movieDescription.text = _movieOverview;
}

- (void)initializePosterImage {
    _moviePosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kMoviesBaseImageURL, _posterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak UIImageView *weakPosterImage = _moviePosterImageView;
    __weak UIView *weakTranslucentView = _translucentView;
    __weak UILabel *weakMovieDescription = _movieDescription;
    [_moviePosterImageView setImageWithURLRequest:request
                                     placeholderImage:loading
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakPosterImage.image = image;
                                                  UIColor *averageColor = AverageColorFromImageWithAlpha(image,0.7f);
                                                  [weakTranslucentView setBackgroundColor:averageColor];
                                                  [weakMovieDescription setTextColor:ContrastColor(averageColor, YES)];
                                              } failure:nil];
}

- (void)initializeBackdropImage {
    _movieBackgroundImageView= [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kMoviesBaseImageURL, _backdropURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak UIImageView *weakbackdropImage = _movieBackgroundImageView;
    
    [_movieBackgroundImageView setImageWithURLRequest:request
                                 placeholderImage:loading
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakbackdropImage.image = image;
                                          } failure:nil];
}

- (void)applyInitialViewConstraints {
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.contentView addSubview:_navBar];
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.contentView);
        make.height.equalTo(@44);
    }];
}

- (void)applyTranslucentViewConstraints {
    [self.contentView addSubview:_translucentView];
    [_translucentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.contentView.mas_width);
        make.bottom.greaterThanOrEqualTo(self.contentView);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
}

- (void)applyDescriptionLabelConstraints {
    [self.contentView addSubview:_movieDescription];
    [_movieDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePosterImageView.mas_bottom).with.offset(20);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.8);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.greaterThanOrEqualTo(self.contentView);
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.movieDescription);
    }];
}

- (void)applyPosterImageConstraints {
    [self.contentView addSubview:_moviePosterImageView];
    [_moviePosterImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.navBar.mas_bottom).with.offset(20);
    }];
}

- (void)applyBackdropImageConstraints {
    [self.contentView addSubview:_movieBackgroundImageView];
    [_movieBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.and.bottom.and.right.equalTo(self.contentView);
    }];
}

@end
