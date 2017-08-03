import Foundation

enum BoxitError: Error {
    case NoInternet
    case ParseError
    case FbAuthError
    case FbAuthCancelled
    case FirAuthError
    case InviteError
    case BackendError
    case NoEventsError
    case NoFavouritesError
}
