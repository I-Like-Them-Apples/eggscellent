//
//  NoteWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <RobotKit/RobotKit.h>
#import "HistoryWindowController.h"
#import "ColorView.h"

@implementation HistoryWindowController
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - memory based methods

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) 
    {
        // Initialization code here.
        _managedObjectContext = [[ModelStore sharedStore] managedObjectContext];
    }

    return self;
}

#pragma mark - NSWindowController Lifecycle

- (void)windowDidLoad
{
    //set up all the pretty window stuffs
    [super windowDidLoad];
    [self.window setLevel:NSFloatingWindowLevel];
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window setOpaque:NO];
    [self.window setStyleMask:NSResizableWindowMask];
    
    [self filterUpThatPredicate];//look i'm sure you from the future is all like "what a lame name, why did he even do that? cause I can. eat it."
     
    //unify the background color for the contentView of the window as well as the content view of the scroll view
    ((ColorView *)self.window.contentView).backgroundColor =
    contentView.backgroundColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    
    arrayController.filterPredicate = [self filterPredicate];
}

- (void)close
{
    [super close];
}

#pragma mark - Internal methods

- (NSPredicate *)filterPredicate
{
    return nil;
}

- (void)updateFirstAndLastDatesWithDelta:(int)delta
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSUInteger components = NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents* comps = [calendar components:components
                                          fromDate:now];
    
    // set first of the month
    [comps setDay:1];
    firstDay = [calendar dateFromComponents:comps];

    // set last of month
    [comps setMonth:[comps month]+1];
    lastDay = [calendar dateFromComponents:comps];

    //this code is saved here because it is used for when we want weeks at a time.
//    NSUInteger components = NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
//    NSDateComponents *nowComponents = [calendar components:components fromDate:now];
//    [nowComponents setWeek:[nowComponents week] - delta];
//
//    [nowComponents setWeekday:1]; // 2: monday
//    firstDay = [calendar dateFromComponents:nowComponents];
//
//    [nowComponents setWeekday:7]; // 7: saturday
//    lastDay = [calendar dateFromComponents:nowComponents];
}

- (void)filterUpThatPredicate
{
    [self updateFirstAndLastDatesWithDelta:0];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completed != nil AND (completed > %@ AND completed < %@)", firstDay, lastDay, nil];
    [fetchRequest setPredicate:predicate];
    
    arrayController.fetchPredicate = predicate;
}

#pragma mark - IBActions

- (IBAction)previousWeekSelected:(id)sender;
{
    
}

- (IBAction)nextWeekSelected:(id)sender;
{
    
}

- (IBAction)clearTextSelected:(id)sender;
{
    
}

- (IBAction)close:(id)sender;
{
    [self close];
}

#pragma mark - Image Drop NoteTextView Notifications

- (void)imageDropped:(NSNotification *)note
{
    
}

#pragma mark - TableView Delegate and Datasource methods

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if(row >= [arrayController.arrangedObjects count])
        return 70;
    
    return 70;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row;
{
    return (row % 2);
}

//- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
////    OverviewTableCellView *result = [itemsTableView makeViewWithIdentifier:@"OverviewTableCellView" owner:self];
////    [result.backgroundClip setHidden:YES];
////    result.tableView = itemsTableView;
////    
////    //set the appropriate selection
////    NSTableRowView *rowView = [itemsTableView rowViewAtRow:row makeIfNecessary:NO];
////    
////    Activity *a = (Activity *)[arrayController.arrangedObjects objectAtIndex:row];
////    result.textField.stringValue = a.name;
////    result.selected = rowView.selected;
////    
////    return result;
//    
//    NSTableCellView *result = [historyTableView makeViewWithIdentifier:@"HistoryTableCellView" owner:self];
//    result.textField.stringValue = @"OH SHIT";
//    return result;
//}

//- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
//{
//    OverviewTableRowView *rowView = [[OverviewTableRowView alloc] init];
//    return rowView;
//}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{

}

@end