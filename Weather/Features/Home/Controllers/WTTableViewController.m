//
//  WTTableViewController.m
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "WTTableViewController.h"
#import "WeatherAnimationViewController.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "UIImageView+AFNetworking.h"

static NSString * const baseUrlString = @"http://www.raywenderlich.com/demos/weather_sample/";
static NSString * const jsonType      = @"json";
static NSString * const plistType     = @"plist";
static NSString * const xmlType       = @"xml";

@interface WTTableViewController ()

@property(strong) NSDictionary *weather;

@property(nonatomic, strong) NSMutableDictionary *currentDictionary;
@property(nonatomic, strong) NSMutableDictionary *xmlWeather;
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outString;

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        WeatherAnimationViewController *wac = (WeatherAnimationViewController *)segue.destinationViewController;
        
        wac.sectionNumber = indexPath.section;
        
        NSDictionary *w;
        switch (indexPath.section) {
            case 0: {
                w = self.weather.currentCondition;
                break;
            }
            case 1: {
                w = [self.weather upcomingWeather][indexPath.row];
                break;
            }
            default: {
                break;
            }
        }
        wac.weatherDictionary = w;
    }
}

#pragma mark - Actions

- (IBAction)clear:(id)sender
{
    self.title = @"";
    self.weather = nil;
    [self.tableView reloadData];
}

- (IBAction)clientTapped:(id)sender
{
    
}

- (IBAction)apiTapped:(id)sender
{
    [_locationManager startUpdatingLocation];
}

#pragma mark - Networking Delegate

- (void)requestSucess:(NSDictionary *)responseObject
{
    _weather = responseObject;
    self.title = [NSString stringWithFormat:@"Data Retrieved"];
    [self.tableView reloadData];
}

- (void)requestFailure:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)requestSucessWithXMLResponse:(NSXMLParser *) NSXMLParser
{
    NSXMLParser.delegate = self;
    [NSXMLParser parse];
}

#pragma mark - NSXMLParser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _xmlWeather = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    _elementName = qName;
    
    if ([qName isEqualToString:@"current_condition"] ||
        [qName isEqualToString:@"weather"] ||
        [qName isEqualToString:@"request"]) {
        _currentDictionary = [NSMutableDictionary dictionary];
    }
    
    _outString = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!_elementName)
        return;
    
    [_outString appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([qName isEqualToString:@"current_condition"] ||
        [qName isEqualToString:@"request"]) {
        
        _xmlWeather[qName] = @[_currentDictionary];
        _currentDictionary = nil;
    }
    else if ([qName isEqualToString:@"weather"]) {
        
        NSMutableArray *array = _xmlWeather[@"weather"] ?: [NSMutableArray array];
        
        // Add the current weather object
        [array addObject:_currentDictionary];
        
        // Set the new array to the "weather" key on xmlWeather dictionary
        _xmlWeather[@"weather"] = array;
        
        _currentDictionary = nil;
    }
    else if ([qName isEqualToString:@"weatherDesc"] ||
             [qName isEqualToString:@"weatherIconUrl"]) {
        NSDictionary *dictionary = @{@"value": _outString};
        NSArray *array = @[dictionary];
        _currentDictionary[qName] = array;
    }
    else if (qName) {
        _currentDictionary[qName] = _outString;
    }
    
    _elementName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    _weather = @{@"data": self.xmlWeather};
    self.title = @"XML Retrieved";
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_weather)
        return 0;
    
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            return [upcomingWeather count];
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *daysWeather = nil;
    
    switch (indexPath.section) {
        case 0 : {
            daysWeather = [self.weather currentCondition];
            break;
        }
        case 1: {
            NSArray *upcomingweather = [self.weather upcomingWeather];
            daysWeather = upcomingweather[indexPath.row];
            break;
        }
        default:
            break;
    }

    cell.textLabel.text = [daysWeather weatherDescriptionForSection:indexPath.section];
    
    [self loadImageWithUrl:[daysWeather weatherIconURLForSection:indexPath.section] forCell:cell];
    
    return cell;
}

#pragma mark - Load Images For Cells

- (void)loadImageWithUrl:(NSString *)urlString forCell:(UITableViewCell *)cell
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:placeholderImage
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    if ([newLocation.timestamp timeIntervalSinceNow] > 300) {
        return;
    }
    
    [_locationManager stopUpdatingLocation];
    
    WeatherHTTPClient *weatherHTTPClient = [WeatherHTTPClient sharedWeatherHTTPClient];
    weatherHTTPClient.delegate = self;
    [weatherHTTPClient updateWeatherAtLocation:newLocation forNumberOfDays:5];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:@"Failed to Get Your Location"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}


#pragma mark - Weather Client Delegate Methods

- (void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather
{
    _weather = weather;
    self.title = @"API Updated";
    [self.tableView reloadData];
}

- (void)weatherHTTPClient:(WeatherHTTPClient *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
