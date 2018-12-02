//
//  ListOfMoviesViewController.m
//  Movies
//
//  Created by gaston on 11/24/18.
//  Copyright © 2018 gaston. All rights reserved.
//

#import "ListOfMoviesViewController.h"
#import "MovieTableViewCell.h"
#import "MoviesAPIConstants.h"
#import "MovieGeneralConstants.h"
#import "MovieData.h"
#import "MovieDescriptionViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"

static NSString *CellIdentifier = @"MovieCell";

@interface ListOfMoviesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *screenTitle;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *topRatedMovies;
@property (strong, nonatomic) NSArray *moviesGenres;

@end

@implementation ListOfMoviesViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Carga inicial de datos de la API
    [self loadTopRatedMoviesData];
    
    // Inciailizar componentes visuales
    [self initializeScreenTitle];
    [self initializeTableview];
}

- (void)viewWillLayoutSubviews {
    // Aplicar constraints necesarios en los componentes visuales
    [self applyScreenTitleConstraints];
    [self applyTableViewConstraints];
}

#pragma mark - private methods

/*
 metodo utilizado para obtener info de la API. Ejecuta un completion block que permite personalizar
 que acciones se deben realizar en el success block.
 De la misma manera se podria agregar un cancel block
*/
- (void)makeRequestWithBaseURL:(NSString *)baseURL andSuccesBlock:(void(^)(id response))success {
    
    NSString *string = [NSString stringWithFormat:@"%@%@", baseURL,kAPIMoviesAPIKey];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@",(NSDictionary *)responseObject);
        success(responseObject);
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

- (void)loadTopRatedMoviesData {
    [self makeRequestWithBaseURL:kAPIMoviesBaseURLString andSuccesBlock:^(id responseObject){
        _topRatedMovies = [responseObject objectForKey:kAPIResultsKey];
        [self loadGenresData];
        [self.tableView reloadData];
    }];
}

- (void)loadGenresData {
    [self makeRequestWithBaseURL:kAPIMoviesGenresBaseURLString andSuccesBlock:^(id responseObject){
        _moviesGenres = [responseObject objectForKey:@"genres"];
        [self.tableView reloadData];
    }];
}

- (void)initializeTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [_tableView setSeparatorColor:[UIColor grayColor]];
    [_tableView setBackgroundColor:[UIColor grayColor]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)initializeScreenTitle {
    _screenTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    _screenTitle.text = @"top rated movies";
    [_screenTitle setFont:[UIFont fontWithName:kGeneralBaseFont size:kScreenTitleSize]];
    [_screenTitle setTextColor:[UIColor whiteColor]];
}

- (void)applyTableViewConstraints {
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenTitle.mas_bottom).with.offset(kGeneralOffset);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.greaterThanOrEqualTo(self.view.mas_bottom);
    }];
}

- (void)applyScreenTitleConstraints {
    [self.view addSubview:_screenTitle];
    
    [_screenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.safeAreaInsets.top);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(kGeneralOffset);
        }
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

/*
 Metodo utilizado para aplicar una transformacion de imagen a las imagenes de las celdas
 Se cambia de color a una escala de grises.
 Si existieran mas metodos como este, se podria crear una extension de UIImage.
*/
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_topRatedMovies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // obtener pelicula para un determinado indexPath row
    NSDictionary *movie = [_topRatedMovies objectAtIndex:[indexPath row]];
    
    // obtener informacion necesaria de esa pelicula para setearse en la celda
    for (NSDictionary *genre in _moviesGenres) {
        if ([genre objectForKey:kAPIIdKey] == [[movie objectForKey:kAPIGenreIdsKey] objectAtIndex:0]) {
            cell.movieGenre.text = [[genre objectForKey:kAPINameKey] uppercaseString];
        }
    }
    cell.movieTitle.text = [movie objectForKey:kAPITitleKey];
    
    // Obtener imagen para setear en celda.
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",kAPIMoviesBaseImageURL, [[_topRatedMovies objectAtIndex:[indexPath row]] objectForKey:kAPIBackdropPathKey]];
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
    return kMovieListRowSize;
}

/*
 Metodo utilizado para preparar informacion de la celda seleccionada necesaria
 para el proximo view controller y navegar hacia dicho view controller.
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieData *movieSelectedData = [[MovieData alloc] init];
    [movieSelectedData setMovieDescription:[[_topRatedMovies objectAtIndex:[indexPath row]] objectForKey:kAPIOverviewKey]];
    [movieSelectedData setBackDropImageURL:[[_topRatedMovies objectAtIndex:[indexPath row]] objectForKey:kAPIBackdropPathKey]];
    [movieSelectedData setPosterPathImageURL:[[_topRatedMovies objectAtIndex:[indexPath row]] objectForKey:kAPIPosterPathKey]];
    
    MovieDescriptionViewController *movieDescriptionVC = [[MovieDescriptionViewController alloc] initWitData:movieSelectedData];
    [self presentViewController:movieDescriptionVC animated:YES completion:nil];
}

@end


