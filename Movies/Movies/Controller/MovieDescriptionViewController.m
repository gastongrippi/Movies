//
//  MovieDescriptionViewController.m
//  Movies
//
//  Created by gaston on 11/26/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "MovieDescriptionViewController.h"
#import "MoviesAPIConstants.h"
#import "MovieGeneralConstants.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>

@interface MovieDescriptionViewController () <UIScrollViewDelegate>

@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIView *contentView;
@property(strong, nonatomic)UIView *translucentView;
@property(strong, nonatomic)UIButton *backButton;

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
    // Inciailizar componentes visuales
    [self setupInitialView];
    [self initializeBackButton];
    [self initializeBackdropImage];
    [self initializeTranslucentView];
    [self initializePosterImage];
    [self initializeDescriptionLabel];
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

- (void)viewWillLayoutSubviews {
    // Aplicar constraints necesarios en los componentes visuales
    [self applyInitialViewConstraints];
    [self applyBackButtonConstraints];
    [self applyBackdropImageConstraints];
    [self applyTranslucentViewConstraints];
    [self applyPosterImageConstraints];
    [self applyDescriptionLabelConstraints];
}

#pragma mark - private methods

- (void)navigateBack {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupInitialView {
    self.view = [[UIView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    _contentView = [[UIView alloc] init];
    self.scrollView.delegate = self;
}

- (void)initializeBackButton {
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchDown];
}

- (void)initializeTranslucentView {
    _translucentView = [[UIView alloc] initWithFrame:CGRectZero];
    [_translucentView setAlpha:0.9];
}


- (void)initializeDescriptionLabel {
    _movieDescription = [[UILabel alloc]initWithFrame:CGRectZero];
    _movieDescription.numberOfLines = 0;
    [_movieDescription setTextAlignment:NSTextAlignmentJustified];
    [_movieDescription setAdjustsFontSizeToFitWidth:NO];
    [_movieDescription setFont:[UIFont fontWithName:kGeneralBaseFont size:kInfoTextSize]];
    _movieDescription.text = _movieOverview;
}

- (void)initializePosterImage {
    _moviePosterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kAPIMoviesBaseImageURL, _posterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIImage *loading = [UIImage imageNamed:@"loading"];
    
    __weak UIImageView *weakPosterImage = _moviePosterImageView;
    __weak MovieDescriptionViewController *weakSelf = self;
    [_moviePosterImageView setImageWithURLRequest:request
                                     placeholderImage:loading
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakPosterImage.image = image;
                                                  UIColor *averageColor = AverageColorFromImage(image);
                                                  [weakSelf setViewsThemesWithAverageColor:averageColor];
                                              } failure:nil];
}

- (void)setViewsThemesWithAverageColor:(UIColor *)averageColor {
    [_translucentView setBackgroundColor:averageColor];
    [_scrollView setBackgroundColor:averageColor];
    [_movieDescription setTextColor:[UIColor colorWithContrastingBlackOrWhiteColorOn:averageColor isFlat:YES]];
}

- (void)initializeBackdropImage {
    _movieBackgroundImageView= [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kAPIMoviesBaseImageURL, _backdropURL];
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
}

- (void)applyBackButtonConstraints {
    [self.contentView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.safeAreaInsets.top + kGeneralOffset);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(kGeneralOffset);
        }
        make.left.equalTo(self.contentView).with.offset(kGeneralOffset);
        make.height.and.width.equalTo(@(30));
    }];
}

- (void)applyTranslucentViewConstraints {
    [self.contentView addSubview:_translucentView];
    [_translucentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.contentView.mas_width);
        make.bottom.greaterThanOrEqualTo(self.contentView);
        make.top.equalTo(self.backButton.mas_bottom);
    }];
}

- (void)applyDescriptionLabelConstraints {
    [self.contentView addSubview:_movieDescription];
    [_movieDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePosterImageView.mas_bottom).with.offset(kGeneralOffset*2);
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
        make.top.equalTo(self.backButton.mas_bottom).with.offset(kGeneralOffset*2);
        make.height.equalTo(@(375));
        make.width.equalTo(@(250));
    }];
}

- (void)applyBackdropImageConstraints {
    [self.contentView addSubview:_movieBackgroundImageView];
    [_movieBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom);
        make.left.and.bottom.and.right.equalTo(self.contentView);
    }];
}

- (void)updatePosterConstraintsWithOffset:(CGFloat)newHeight {
    [_moviePosterImageView mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(newHeight));
    }];
}

#pragma mark - scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // TODO: El resizing se esta aplicando solo a la altura de la imagen, pero
    // se deberia hacer teniendo en cuenta el aspect Ratio
    CGFloat newHeight = 375 - (_scrollView.contentOffset.y + 20.0f);
    newHeight = MAX(200, newHeight);
    [self updatePosterConstraintsWithOffset:newHeight];
}

@end
