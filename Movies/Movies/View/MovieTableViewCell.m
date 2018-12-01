//
//  MovieTableViewCell.m
//  Movies
//
//  Created by gaston on 11/25/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "MovieGeneralConstants.h"
#import "Masonry.h"

@interface MovieTableViewCell ()
@property (assign, nonatomic) BOOL didSetupConstraints;
@end

@implementation MovieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitialView];
        [self iniatilizeMovieBackgroundImage];
        [self intiatilizeMovieTitle];
        [self intiatilizeMovieGenre];
    }

    return self;
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        [self applyMovieBackgroundImageConstraints];
        [self applyMovieTitleConstraints];
        [self applyMovieGenreConstraints];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

#pragma mark - private methods

- (void)setupInitialView {
    [self setBackgroundColor:[UIColor grayColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setBackgroundColor:[UIColor grayColor]];
}

- (void)iniatilizeMovieBackgroundImage {
    _movieBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_movieBackgroundImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _movieBackgroundImage.layer.masksToBounds = YES;
    _movieBackgroundImage.layer.cornerRadius = 20.0;
}

- (void)intiatilizeMovieTitle {
    _movieTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [_movieTitle setTextColor:[UIColor whiteColor]];
    [_movieTitle setFont:[UIFont fontWithName:kGeneralBaseFont size:20]];
}

- (void)intiatilizeMovieGenre {
    _movieGenre = [[UILabel alloc] initWithFrame:CGRectZero];
    [_movieGenre setTextColor:[UIColor whiteColor]];
    [_movieGenre setFont:[UIFont fontWithName:kGeneralBaseFont size:15]];
    [_movieGenre setBackgroundColor:[UIColor grayColor]];
}

- (void)applyMovieBackgroundImageConstraints {
    [self.contentView addSubview:_movieBackgroundImage];
    [_movieBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
}

- (void)applyMovieTitleConstraints {
    [self.contentView addSubview:_movieTitle];
    [_movieTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieBackgroundImage.mas_left).with.offset(10);
        make.bottom.equalTo(self.movieBackgroundImage.mas_bottom).with.offset(-10);
        make.width.equalTo(self.movieBackgroundImage.mas_width).with.offset(-10);
    }];
}

- (void)applyMovieGenreConstraints {
    [self.contentView addSubview:_movieGenre];
    [_movieGenre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.movieBackgroundImage.mas_right).with.offset(-10);
        make.top.equalTo(self.movieBackgroundImage.mas_top).with.offset(10);
    }];
}


@end
