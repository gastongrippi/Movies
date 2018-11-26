//
//  movieData.m
//  Movies
//
//  Created by gaston on 11/25/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "movieData.h"

@interface movieData()

@end

@implementation movieData

- (instancetype)initWithData:(NSArray *)resultData {
    self = [super init];
    if (self) {
        _moviesResults = resultData;
    }
    
    return self;
}

@end
