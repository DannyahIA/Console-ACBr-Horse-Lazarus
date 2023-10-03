unit nfse_http_statuscode;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils;

const
  FStatusContinue = 100;
  FStatusSwitchingProtocols = 101;// RFC 9110;15.2.2
  FStatusProcessing = 102;// RFC 2518;10.1
  FStatusEarlyHints = 103;// RFC 8297
  FStatusOK = 200;// RFC 9110;15.3.1
  FStatusCreated = 201;// RFC 9110;15.3.2
  FStatusAccepted = 202;// RFC 9110;15.3.3
  FStatusNonAuthoritativeInfo = 203;// RFC 9110;15.3.4
  FStatusNoContent = 204;// RFC 9110;15.3.5
  FStatusResetContent = 205;// RFC 9110;15.3.6
  FStatusPartialContent = 206;// RFC 9110;15.3.7
  FStatusMultiFStatus = 207;// RFC 4918;11.1
  FStatusAlreadyReported = 208;// RFC 5842;7.1
  FStatusIMUsed = 226;// RFC 3229;10.4.1
  FStatusMultipleChoices = 300;// RFC 9110;15.4.1
  FStatusMovedPermanently = 301;// RFC 9110;15.4.2
  FStatusFound = 302;// RFC 9110;15.4.3
  FStatusSeeOther = 303;// RFC 9110;15.4.4
  FStatusNotModified = 304;// RFC 9110;15.4.5
  FStatusUseProxy = 305;// RFC 9110;15.4.6
  _ = 306;// RFC 9110;15.4.7 (Unused)
  FStatusTemporaryRedirect = 307;// RFC 9110;15.4.8
  FStatusPermanentRedirect = 308;// RFC 9110;15.4.9
  FStatusBadRequest = 400;// RFC 9110;15.5.1
  FStatusUnauthorized = 401;// RFC 9110;15.5.2
  FStatusPaymentRequired = 402;// RFC 9110;15.5.3
  FStatusForbidden = 403;// RFC 9110;15.5.4
  FStatusNotFound = 404;// RFC 9110;15.5.5
  FStatusMethodNotAllowed = 405;// RFC 9110;15.5.6
  FStatusNotAcceptable = 406;// RFC 9110;15.5.7
  FStatusProxyAuthRequired = 407;// RFC 9110;15.5.8
  FStatusRequestTimeout = 408;// RFC 9110;15.5.9
  FStatusConflict = 409;// RFC 9110;15.5.10
  FStatusGone = 410;// RFC 9110;15.5.11
  FStatusLengthRequired = 411;// RFC 9110;15.5.12
  FStatusPreconditionFailed = 412;// RFC 9110;15.5.13
  FStatusRequestEntityTooLarge = 413;// RFC 9110;15.5.14
  FStatusRequestURITooLong = 414;// RFC 9110;15.5.15
  FStatusUnsupportedMediaType = 415;// RFC 9110;15.5.16
  FStatusRequestedRangeNotSatisfiable = 416;// RFC 9110;15.5.17
  FStatusExpectationFailed = 417;// RFC 9110;15.5.18
  FStatusTeapot = 418;// RFC 9110;15.5.19 (Unused)
  FStatusMisdirectedRequest = 421;// RFC 9110;15.5.20
  FStatusUnprocessableEntity = 422;// RFC 9110;15.5.21
  FStatusLocked = 423;// RFC 4918;11.3
  FStatusFailedDependency = 424;// RFC 4918;11.4
  FStatusTooEarly = 425;// RFC 8470;5.2.
  FStatusUpgradeRequired = 426;// RFC 9110;15.5.22
  FStatusPreconditionRequired = 428;// RFC 6585;3
  FStatusTooManyRequests = 429;// RFC 6585;4
  FStatusRequestHeaderFieldsTooLarge = 431;// RFC 6585;5
  FStatusUnavailableForLegalReasons = 451;// RFC 7725;3
  FStatusInternalServerError = 500;// RFC 9110;15.6.1
  FStatusNotImplemented = 501;// RFC 9110;15.6.2
  FStatusBadGateway = 502;// RFC 9110;15.6.3
  FStatusServiceUnavailable = 503;// RFC 9110;15.6.4
  FStatusGatewayTimeout = 504;// RFC 9110;15.6.5
  FStatusHTTPVersionNotSupported = 505;// RFC 9110;15.6.6
  FStatusVariantAlsoNegotiates = 506;// RFC 2295;8.1
  FStatusInsufficientStorage = 507;// RFC 4918;11.5
  FStatusLoopDetected = 508;// RFC 5842;7.2
  FStatusNotExtended = 510;// RFC 2774;7
  FStatusNetworkAuthenticationRequired = 511;// RFC 6585;6

type

  { TNTHttpStatusCode }
  TNTHttpStatusCode = class
  public
    class function StatusOK: integer;
    class function StatusContinue: integer;
    class function StatusSwitchingProtocols: integer;
    class function StatusProcessing: integer;
    class function StatusEarlyHints: integer;
    class function StatusCreated: integer;
    class function StatusAccepted: integer;
    class function StatusNonAuthoritativeInfo: integer;
    class function StatusNoContent: integer;
    class function StatusResetContent: integer;
    class function StatusPartialContent: integer;
    class function StatusMultiStatus: integer;
    class function StatusAlreadyReported: integer;
    class function StatusIMUsed: integer;
    class function StatusMultipleChoices: integer;
    class function StatusMovedPermanently: integer;
    class function StatusFound: integer;
    class function StatusSeeOther: integer;
    class function StatusNotModified: integer;
    class function StatusUseProxy: integer;
    class function _: integer;
    class function StatusTemporaryRedirect: integer;
    class function StatusPermanentRedirect: integer;
    class function StatusBadRequest: integer;
    class function StatusUnauthorized: integer;
    class function StatusPaymentRequired: integer;
    class function StatusForbidden: integer;
    class function StatusNotFound: integer;
    class function StatusMethodNotAllowed: integer;
    class function StatusNotAcceptable: integer;
    class function StatusProxyAuthRequired: integer;
    class function StatusRequestTimeout: integer;
    class function StatusConflict: integer;
    class function StatusGone: integer;
    class function StatusLengthRequired: integer;
    class function StatusPreconditionFailed: integer;
    class function StatusRequestEntityTooLarge: integer;
    class function StatusRequestURITooLong: integer;
    class function StatusUnsupportedMediaType: integer;
    class function StatusRequestedRangeNotSatisfiable: integer;
    class function StatusExpectationFailed: integer;
    class function StatusTeapot: integer;
    class function StatusMisdirectedRequest: integer;
    class function StatusUnprocessableEntity: integer;
    class function StatusLocked: integer;
    class function StatusFailedDependency: integer;
    class function StatusTooEarly: integer;
    class function StatusUpgradeRequired: integer;
    class function StatusPreconditionRequired: integer;
    class function StatusTooManyRequests: integer;
    class function StatusRequestHeaderFieldsTooLarge: integer;
    class function StatusUnavailableForLegalReasons: integer;
    class function StatusInternalServerError: integer;
    class function StatusNotImplemented: integer;
    class function StatusBadGateway: integer;
    class function StatusServiceUnavailable: integer;
    class function StatusGatewayTimeout: integer;
    class function StatusHTTPVersionNotSupported: integer;
    class function StatusVariantAlsoNegotiates: integer;
    class function StatusInsufficientStorage: integer;
    class function StatusLoopDetected: integer;
    class function StatusNotExtended: integer;
    class function StatusNetworkAuthenticationRequired: integer;
  end;

implementation

{ TNTHttpStatusCode }
class function TNTHttpStatusCode.StatusOK: integer;
begin
  Result := FStatusOk;
end;

class function TNTHttpStatusCode.StatusContinue: integer;
begin
  Result := FStatusContinue;
end;

class function TNTHttpStatusCode.StatusSwitchingProtocols: integer;
begin
  Result := FStatusSwitchingProtocols;
end;

class function TNTHttpStatusCode.StatusProcessing: integer;
begin
  Result := FStatusProcessing;
end;

class function TNTHttpStatusCode.StatusEarlyHints: integer;
begin
  Result := FStatusEarlyHints;
end;

class function TNTHttpStatusCode.StatusCreated: integer;
begin
  Result := FStatusCreated;
end;

class function TNTHttpStatusCode.StatusAccepted: integer;
begin
  Result := FStatusAccepted;
end;

class function TNTHttpStatusCode.StatusNonAuthoritativeInfo: integer;
begin
  Result := FStatusNonAuthoritativeInfo;
end;

class function TNTHttpStatusCode.StatusNoContent: integer;
begin
  Result := FStatusNoContent;
end;

class function TNTHttpStatusCode.StatusResetContent: integer;
begin
  Result := FStatusResetContent;
end;

class function TNTHttpStatusCode.StatusPartialContent: integer;
begin
  Result := FStatusPartialContent;
end;

class function TNTHttpStatusCode.StatusMultiStatus: integer;
begin
  Result := FStatusMultiStatus;
end;

class function TNTHttpStatusCode.StatusAlreadyReported: integer;
begin
  Result := FStatusAlreadyReported;
end;

class function TNTHttpStatusCode.StatusIMUsed: integer;
begin
  Result := FStatusIMUsed;
end;

class function TNTHttpStatusCode.StatusMultipleChoices: integer;
begin
  Result := FStatusMultipleChoices;
end;

class function TNTHttpStatusCode.StatusMovedPermanently: integer;
begin
  Result := FStatusMovedPermanently;
end;

class function TNTHttpStatusCode.StatusFound: integer;
begin
  Result := FStatusFound;
end;

class function TNTHttpStatusCode.StatusSeeOther: integer;
begin
  Result := FStatusSeeOther;
end;

class function TNTHttpStatusCode.StatusNotModified: integer;
begin
  Result := FStatusNotModified;
end;

class function TNTHttpStatusCode.StatusUseProxy: integer;
begin
  Result := FStatusUseProxy;
end;

class function TNTHttpStatusCode._: integer;
begin
  Result := _;
end;

class function TNTHttpStatusCode.StatusTemporaryRedirect: integer;
begin
  Result := FStatusTemporaryRedirect;
end;

class function TNTHttpStatusCode.StatusPermanentRedirect: integer;
begin
  Result := FStatusPermanentRedirect;
end;

class function TNTHttpStatusCode.StatusBadRequest: integer;
begin
  Result := FStatusBadRequest;
end;

class function TNTHttpStatusCode.StatusUnauthorized: integer;
begin
  Result := FStatusUnauthorized;
end;

class function TNTHttpStatusCode.StatusPaymentRequired: integer;
begin
  Result := FStatusPaymentRequired;
end;

class function TNTHttpStatusCode.StatusForbidden: integer;
begin
  Result := FStatusForbidden;
end;

class function TNTHttpStatusCode.StatusNotFound: integer;
begin
  Result := FStatusNotFound;
end;

class function TNTHttpStatusCode.StatusMethodNotAllowed: integer;
begin
  Result := FStatusMethodNotAllowed;
end;

class function TNTHttpStatusCode.StatusNotAcceptable: integer;
begin
  Result := FStatusNotAcceptable;
end;

class function TNTHttpStatusCode.StatusProxyAuthRequired: integer;
begin
  Result := FStatusProxyAuthRequired;
end;

class function TNTHttpStatusCode.StatusRequestTimeout: integer;
begin
  Result := FStatusRequestTimeout;
end;

class function TNTHttpStatusCode.StatusConflict: integer;
begin
  Result := FStatusConflict;
end;

class function TNTHttpStatusCode.StatusGone: integer;
begin
  Result := FStatusGone;
end;

class function TNTHttpStatusCode.StatusLengthRequired: integer;
begin
  Result := FStatusLengthRequired;
end;

class function TNTHttpStatusCode.StatusPreconditionFailed: integer;
begin
  Result := FStatusPreconditionFailed;
end;

class function TNTHttpStatusCode.StatusRequestEntityTooLarge: integer;
begin
  Result := FStatusRequestEntityTooLarge;
end;

class function TNTHttpStatusCode.StatusRequestURITooLong: integer;
begin
  Result := FStatusRequestURITooLong;
end;

class function TNTHttpStatusCode.StatusUnsupportedMediaType: integer;
begin
  Result := FStatusUnsupportedMediaType;
end;

class function TNTHttpStatusCode.StatusRequestedRangeNotSatisfiable: integer;
begin
  Result := FStatusRequestedRangeNotSatisfiable;
end;

class function TNTHttpStatusCode.StatusExpectationFailed: integer;
begin
  Result := FStatusExpectationFailed;
end;

class function TNTHttpStatusCode.StatusTeapot: integer;
begin
  Result := FStatusTeapot;
end;

class function TNTHttpStatusCode.StatusMisdirectedRequest: integer;
begin
  Result := FStatusMisdirectedRequest;
end;

class function TNTHttpStatusCode.StatusUnprocessableEntity: integer;
begin
  Result := FStatusUnprocessableEntity;
end;

class function TNTHttpStatusCode.StatusLocked: integer;
begin
  Result := FStatusLocked;
end;

class function TNTHttpStatusCode.StatusFailedDependency: integer;
begin
  Result := FStatusFailedDependency;
end;

class function TNTHttpStatusCode.StatusTooEarly: integer;
begin
  Result := FStatusTooEarly;
end;

class function TNTHttpStatusCode.StatusUpgradeRequired: integer;
begin
  Result := FStatusUpgradeRequired;
end;

class function TNTHttpStatusCode.StatusPreconditionRequired: integer;
begin
  Result := FStatusPreconditionRequired;
end;

class function TNTHttpStatusCode.StatusTooManyRequests: integer;
begin
  Result := FStatusTooManyRequests;
end;

class function TNTHttpStatusCode.StatusRequestHeaderFieldsTooLarge: integer;
begin
  Result := FStatusRequestHeaderFieldsTooLarge;
end;

class function TNTHttpStatusCode.StatusUnavailableForLegalReasons: integer;
begin
  Result := FStatusUnavailableForLegalReasons;
end;

class function TNTHttpStatusCode.StatusInternalServerError: integer;
begin
  Result := FStatusInternalServerError;
end;

class function TNTHttpStatusCode.StatusNotImplemented: integer;
begin
  Result := FStatusNotImplemented;
end;

class function TNTHttpStatusCode.StatusBadGateway: integer;
begin
  Result := FStatusBadGateway;
end;

class function TNTHttpStatusCode.StatusServiceUnavailable: integer;
begin
  Result := FStatusServiceUnavailable;
end;

class function TNTHttpStatusCode.StatusGatewayTimeout: integer;
begin
  Result := FStatusGatewayTimeout;
end;

class function TNTHttpStatusCode.StatusHTTPVersionNotSupported: integer;
begin
  Result := FStatusHTTPVersionNotSupported;
end;

class function TNTHttpStatusCode.StatusVariantAlsoNegotiates: integer;
begin
  Result := FStatusVariantAlsoNegotiates;
end;

class function TNTHttpStatusCode.StatusInsufficientStorage: integer;
begin
  Result := FStatusInsufficientStorage;
end;

class function TNTHttpStatusCode.StatusLoopDetected: integer;
begin
  Result := FStatusLoopDetected;
end;

class function TNTHttpStatusCode.StatusNotExtended: integer;
begin
  Result := FStatusNotExtended;
end;

class function TNTHttpStatusCode.StatusNetworkAuthenticationRequired: integer;
begin
  Result := FStatusNetworkAuthenticationRequired;
end;

end.
