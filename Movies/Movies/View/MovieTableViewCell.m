//
//  MovieTableViewCell.m
//  Movies
//
//  Created by gaston on 11/25/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "Masonry.h"

@interface MovieTableViewCell ()
@property (assign, nonatomic) BOOL didSetupConstraints;
@end

@implementation MovieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _movieBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_movieBackgroundImage setTranslatesAutoresizingMaskIntoConstraints:NO];

        _movieTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_movieTitle setBackgroundColor:[UIColor cyanColor]];
        
        [self.contentView addSubview:_movieBackgroundImage];
        [self.contentView addSubview:_movieTitle];
    }
    
    return self;
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        [_movieTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [_movieBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
