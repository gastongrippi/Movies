//
//  MoviesAPIConstants.m
//  Movies
//
//  Created by gaston on 11/25/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "MoviesAPIConstants.h"

@implementation MoviesAPIConstants

NSString *const kAPIMoviesAPIKey = @"208ca80d1e219453796a7f9792d16776";
NSString *const kAPIMoviesBaseURLString = @"https://api.themoviedb.org/3/movie/top_rated?api_key=";
NSString *const kAPIMoviesGenresBaseURLString = @"https://api.themoviedb.org/3/genre/movie/list?api_key=";
NSString *const kAPIMoviesBaseImageURL = @"https://image.tmdb.org/t/p/w500";
NSString *const kAPIResultsKey = @"results";
NSString *const kAPITitleKey = @"title";
NSString *const kAPIBackdropPathKey = @"backdrop_path";
NSString *const kAPIPosterPathKey = @"poster_path";
NSString *const kAPIOverviewKey = @"overview";
NSString *const kAPIGenreIdsKey = @"genre_ids";
NSString *const kAPIIdKey = @"id";
NSString *const kAPINameKey = @"name";

@end
