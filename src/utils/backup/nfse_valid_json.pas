unit nfse_valid_json;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Jsons;

type
  IValidJson = interface
    function IsValidJson(JsonStr: string): TJson;
  end;

type
  TValidJson = class(TInterfacedObject, IValidJson)
  private

  public
    { JSON IS VALID }
    function IsValidJson(JsonStr: string): TJson;
  end;

implementation

function TValidJson.IsValidJson(JsonStr: string): TJson;
var
  Json: TJson;
begin
  Json := TJson.Create;

  try
    Json.Parse(JsonStr);
    Result := Json;
  except
    Result := nil
  end;
end;

end.
