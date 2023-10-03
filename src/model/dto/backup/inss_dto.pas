unit inss_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IInss }
  IInss = interface
  end;

  { TInss }
  TInss = class(TInterfacedObject, IInss)
    Aliquota: double;
    Valor: double;
  private

  public
    class function New: IInss;
  end;

implementation

{ TInss }
class function TInss.New: IInss;
begin
  Result := self.Create;
end;

end.
