#ifndef PivotPong_Constants_h
#define PivotPong_Constants_h

// api //
static NSString * const PivotPongApiURLs                      = @"apiURLs";
static NSString * const PivotPongApiGetPlayersKey             = @"getPlayers";
static NSString * const PivotPongApiGetMatchesKey             = @"getMatches";
static NSString * const PivotPongApiPostMatchKey              = @"postMatch";
static NSString * const PivotPongApiGetPlayersJSONResponseKey = @"players";
static NSString * const PivotPongApiPostMatchJSONResponseKey  = @"match";
static NSString * const PivotPongApiGetMatchesJSONResponseKey = @"matches";

static NSString * const PivotPongApiAuthenticityTokenKey      = @"authToken";

// user defaults //
static NSString * const PivotPongCurrentUserKey               = @"currentUser";

// presentation //
static NSString * const PivotPongPlayerTableViewCellKey       = @"PlayerCell";
static NSString * const PivotPongMatchesTableViewCellKey      = @"MatchPrototypeCell";
static NSString * const PivotPongPlayerNameKey                = @"name";
static NSString * const PivotPongWinnerKey                    = @"winner";
static NSString * const PivotPongLoserKey                     = @"loser";

enum {
    PivotPongErrorCodeServerError
} typedef PivotPongErrorCode;

#endif
