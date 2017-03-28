#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SBMediaController.h>
#import <substrate.h>

@interface SearchUIPlayButtonViewController
@property (nonatomic,copy) NSString * playItemIdentifier;  
@property (nonatomic,copy) NSString * mediaURLString;
-(void)buttonPressed;
@end
@interface SFSearchResult_Compatibility
@property (nonatomic,retain) NSString * bundleID;
@property (nonatomic,retain) NSString * simpleTitle; 
@end
%group iOS6
%hook SBSearchController

- (void)searchBarSearchButtonClicked:(id)arg1
{
    %orig;
    UITableView * table = MSHookIvar<UITableView *>(self, "_tableView");
    [self tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

%end
%end



%group iOS7
%hook SBSearchViewController

- (void)_searchFieldReturnPressed
{
    %orig;
    UITableView * table = MSHookIvar<UITableView *>(self, "_tableView");
    [self tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

%end
%end

%group iOS9
%hook SPUISearchViewController

- (void)_searchFieldReturnPressed
{
    %orig;
    UITableView * table = MSHookIvar<UITableView *>(self, "_tableView");
    [self tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

%end
%end

%group iOS10
static UITableViewController * table;
static UITableView * tableView;
static SFSearchResult_Compatibility * query;
static SearchUIPlayButtonViewController * controller;
%hook SPUITableViewController
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2{
    tableView = arg1;
    return %orig;
}
%end
%hook SPUISearchHeader
- (BOOL)textFieldShouldReturn:(id)arg1{
    [table tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return %orig;
}
%end
%hook SearchUIPlayButtonViewController
-(void)updatePlayState{
    controller = self;
    %orig;
}
%end
%hook SPUISearchViewController
-(void)didSelectResult:(id)arg1 withFeedback:(id)arg2 wasPop:(BOOL)arg3{
    if([NSStringFromClass([arg1 class]) isEqualToString:@"SFSearchResult_Compatibility"]){
        query = arg1;
        SBApplication* app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"];
        if([query.bundleID isEqualToString:@"com.apple.Music"] && ![query.simpleTitle isEqualToString:app.displayName])
            [controller buttonPressed];
        else
            %orig;
    }
    else %orig;
}
- (id)activeViewController{
    table = MSHookIvar<UITableViewController *>(self, "_searchTableViewController");
    return %orig;
}
%end
%end

%ctor {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        %init(iOS10);
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        %init(iOS9);
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        %init(iOS7);
    } else {
        %init(iOS6);
    }
}

