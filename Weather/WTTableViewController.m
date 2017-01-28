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

static NSString * const baseUrlString = @"http://www.raywenderlich.com/demos/weather_sample/";

@interface WTTableViewController ()
@property(strong) NSDictionary *weather;
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        WeatherAnimationViewController *wac = (WeatherAnimationViewController *)segue.destinationViewController;
        
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

- (IBAction)jsonTapped:(id)sender
{
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", baseUrlString];
    NSURL *url = [NSURL URLWithString:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _weather = (NSDictionary *)responseObject;
        self.title = @"JSON Retrieved";
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (IBAction)plistTapped:(id)sender
{
    
}

- (IBAction)xmlTapped:(id)sender
{
    
}

- (IBAction)clientTapped:(id)sender
{
    
}

- (IBAction)apiTapped:(id)sender
{
    
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
    
    cell.textLabel.text = [daysWeather weatherDescription];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}


@end
