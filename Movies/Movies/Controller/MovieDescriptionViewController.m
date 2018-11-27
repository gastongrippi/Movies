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


@interface MovieDescriptionViewController ()

@property(strong, nonatomic)UIImageView *movieBackgroundImageView;
@property(strong, nonatomic)UIImageView *moviePosterImageView;
@property(strong, nonatomic)UILabel *movieDescription;

@property(strong, nonatomic)NSString *movieOverview;
@property(strong, nonatomic)NSString *backdropURL;
@property(strong, nonatomic)NSString *posterURL;

@end

@implementation MovieDescriptionViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDescriptionLabel];
    [self initializePosterImage];
    [self initializeBackdropImage];
    
    [self applyPosterImageConstraints];
    [self applyBackdropImageConstraints];
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

- (void)initializeDescriptionLabel {
    _movieDescription = [[UILabel alloc]initWithFrame:CGRectZero];
    _movieDescription.text = _movieOverview;
}

- (void)initializePosterImage {
    _moviePosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kMoviesBaseImageURL, _posterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak UIImageView *weakPosterImage = _moviePosterImageView;

    [_moviePosterImageView setImageWithURLRequest:request
                                     placeholderImage:loading
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakPosterImage.image = image;
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

- (void)applyDescriptionLabelConstraints {
    
}

- (void)applyPosterImageConstraints {
    
}

- (void)applyBackdropImageConstraints {
    
}

@end
