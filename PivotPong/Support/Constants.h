#ifndef PivotPong_Constants_h
#define PivotPong_Constants_h

// api //
static NSString * const PivotPongApiURLs                      = @"apiURLs";
static NSString * const PivotPongApiGetPlayersKey             = @"getPlayers";
static NSString * const PivotPongApiGetMatchesKey             = @"getMatches";
static NSString * const PivotPongApiPostMatchKey              = @"postMatch";
static NSString * const PivotPongApiGetPlayersJSONResponseKey = @"players";
static NSString * const PivotPongApiPostMatchJSONResponseKey  = @"match";
static NSString * const PivotPongApiMatchesWinnerKey          = @"winner";
static NSString * const PivotPongApiMatchesLoserKey           = @"loser";
static NSString * const PivotPongApiPlayerNameKey             = @"name";

// user defaults //
static NSString * const PivotPongCurrentUserKey               = @"currentUser";

// presentation //
static NSString * const PivotPongPlayerTableViewCellKey       = @"PlayerCell";
static NSString * const PivotPongMatchesTableViewCellKey      = @"MatchPrototypeCell";

enum {
    PivotPongErrorCodeServerError
} typedef PivotPongErrorCode;

#endif
