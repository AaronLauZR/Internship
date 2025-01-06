program ConsolePatterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

//Star Pyramid
procedure PrintStar(n: Integer);
var
  x, y: Integer;

begin
  for x := 1 to n do
  begin
    for y := 1 to n - x do
      Write(' ');

    for y := 1 to 2 * x - 1 do
      Write('*');

    Writeln;
  end;

  for x := n - 1 downto 1 do
  begin
    for y := 1 to n - x do
      Write(' ');

    for y := 1 to 2 * x - 1 do
      Write('*');

    Writeln;
  end;
end;

//Number Pyramid
procedure PrintNumber(n: Integer);
var
  x, y: Integer;

begin
  for x := 1 to n do
  begin
    for y := 1 to n - x do
      Write(' ');

      for y := 1 to x do
        Write(y);

      for y := x - 1 downto 1 do
       Write(y);

    Writeln;
  end;

  for x := n - 1 downto 1 do
  begin
    for y := n - 1 downto x do
      Write(' ');

    for y := 1 to x do
      Write(y);

    for y := x - 1 downto 1 do
      Write(y);

    WriteLn;
  end;
end;

//Character Pyramid
procedure PrintCharacter(n: Integer);
var
  x, y, z: Integer;
  CurrentChar: Char;
  CharArray: array[0..25] of Char;

begin
  CurrentChar := 'A';

  for z := 0 to 25 do
  begin
    //Start from 'A' and Store in Array
    CharArray[z] := CurrentChar; 

    //Inc() = Increase Numeric Variables by 1
    Inc(CurrentChar); 
  end;

  for x := 0 to n - 1 do
  begin
    for y := 0 to n - x - 2 do
    Write(' ');

    for y := 0 to x do
      Write(CharArray[y]);

    for y := x - 1 downto 0 do
      Write(CharArray[y]);

    Writeln;
  end;

  for x := n - 2 downto 0 do
  begin
    for y := n - 2 downto x do
      Write(' ');

    for y := 0 to x do
      Write(CharArray[y]);

    for y := x - 1 downto 0 do
      Write(CharArray[y]);

    WriteLn;
  end;
end;

//Star Shape Pyramid
procedure PrintStarShape(n: Integer);
var
  x, y: Integer;

begin
  for x := 1 to n do
  begin
    for y := 1 to n - x do
      Write(' ');

    Write('*');

    for y := 1 to 2 * x - 3 do
      Write(' ');

    if (x <> 1) then
      Write('*');

    Writeln;
  end;

  for x := n - 1 downto 1 do
  begin
    for y := 1 to n - x do
      Write(' ');

    Write('*');

      for y := 1 to 2 * x - 3 do
      Write(' ');

    if (x <> 1) then
      Write('*');

    Writeln;
  end;
end;

//Main Section
var
  number: Integer;

begin
  //Get User Input
  Write('Enter the number of layer: ');
  Readln(number);
  WriteLn;

  //Call Star Pyramid
  PrintStar(number);
  WriteLn;

  //Call Number Pyramid
  PrintNumber(number);
  WriteLn;

  //Call Character Pyramid
  PrintCharacter(number);
  WriteLn;

  //Call Star Shape Pyramid
  PrintStarShape(number);

  ReadLn;
end.
