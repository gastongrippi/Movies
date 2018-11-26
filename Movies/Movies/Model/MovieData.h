//
//  MovieData.h
//  Movies
//
//  Created by gaston on 11/25/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieData : NSObject

@property(strong, nonatomic)NSArray *moviesResults;

- (instancetype)initWithData:(NSArray *)resultData;

@end
