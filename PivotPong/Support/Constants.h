#ifndef PivotPong_Constants_h
#define PivotPong_Constants_h

static NSString * const PivotPongApiURLs                = @"apiURLs";
static NSString * const PivotPongGetPlayers             = @"getPlayers";
static NSString * const PivotPongJSONResponsePlayersKey = @"players";
static NSString * const PivotPongCurrentUserKey         = @"currentUser";
static NSString * const PivotPongPlayerTableViewCellKey = @"PlayerCell";
static NSString * const PivotPongPlayerNameKey          = @"name";

enum {
    PivotPongErrorCodeServerError
} typedef PivotPongErrorCodes;

#endif
