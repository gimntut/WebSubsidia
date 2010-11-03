///////////////////////////////////////////////////////////////////////
//   Набор компонент для отображения элеменотов активного дерева     //
//                                                                   //
//                                                                   //
//                  Copyright Гимаев Наиль 2005г.                    //
//                                                                   //
///////////////////////////////////////////////////////////////////////
// Модифицирован 17/08/2005
unit MyTree;

interface
Uses Classes, ComCtrls, ActnList, MyLists, StdCtrls, ComboEditX, ExtCtrls;
type
 TTreeViewMode=(ViewAsList,ViewAsTree);
 TNodeType=(ntAction,ntString);
 TActiveNodes=Class;
 //////////////////////////////////////////////////
 //////////////////////////////////////////////////
 TActiveNode=Class(TPersistent)
 private
  FImageIndex: integer;
  FIndex: integer;
  FLevel: Integer;
  FCaption: String;
  FAction: TAction;
  FParent: TActiveNode;
  FChildren: TActiveNodes;
  FNodeType: TNodeType;
  procedure SetAction(const Value: TAction);
  procedure SetCaption(const Value: String);
  procedure SetChildren(const Value: TActiveNodes);
  procedure SetImageIndex(const Value: integer);
  procedure SetIndex(const Value: integer);
  procedure SetLevel(const Value: Integer);
  procedure SetNodeType(const Value: TNodeType);
  procedure SetParent(const Value: TActiveNode);
 public 
  property NodeType:TNodeType read FNodeType write SetNodeType;
  property Caption:String read FCaption write SetCaption;
  property Action:TAction read FAction write SetAction;
  property Index:integer read FIndex write SetIndex;
  property ImageIndex:integer read FImageIndex write SetImageIndex;
  property Parent:TActiveNode read FParent write SetParent;
  property Children:TActiveNodes read FChildren write SetChildren;
  property Level:Integer read FLevel write SetLevel;
  procedure Assign(Source: TPersistent); override;
 End;
 //////////////////////////////////////////////////
 TActiveNodes=Class(TPersistent)
 private
  MaxInd: integer;
  FLevel: integer;
  FNodes: array of TActiveNode;
  function GetNodes(x: integer): TActiveNode;
  procedure SetLevel(const Value: integer);
  procedure SetNodes(x: integer; const Value: TActiveNode);
  function GetCount: integer;
 public
  property Nodes[x:integer]:TActiveNode read GetNodes write SetNodes; default;
  property Count:integer read GetCount;
  property Level:integer read FLevel write SetLevel;
  procedure Assign(Source: TPersistent); override;
  procedure Clear;
  procedure Delete(x:integer);
  Function Add(Node:TActiveNode):integer;
  Function Insert(X:integer;Node:TActiveNode):integer;
  destructor Destroy; override;
 End;
 //////////////////////////////////////////////////
 TCustomActiveTree=Class(TComponent)
 private
  CurrentNode:TActiveNode;
  FItems: TActiveNodes;
  procedure SetItems(const Value: TActiveNodes);
 public
  procedure Add(Node:TActiveNode);
  procedure AddToList(sts:TStrings;Index:Integer=-1); overload;
  procedure AddToList(sts:TStrings;s:String); overload;
  procedure AddToList(cb:TComboEditX); overload;
  procedure AddToList(cb:TComboBox); overload;
  procedure AddToList(gd:TNewGrid;Col:integer=-1; Row:integer=-1); overload;
  procedure AddToList(Acts:array of TAction); overload;
  procedure AddToList(ActList:TActionList;ACategory:String=''); overload;
  constructor Create(AOwner: TComponent); override;
 published
  property Items:TActiveNodes read FItems write SetItems;
 End;
 //////////////////////////////////////////////////
 TActiveTree=Class(TCustomActiveTree)
 End;
 //////////////////////////////////////////////////
 TActiveTreeView=Class(TCustomPanel)
 private
  FTree: TActiveTree;
  FMode: TTreeViewMode;
  FTreeView: TTreeView;
  FListView: TListView;
  procedure SetMode(const Value: TTreeViewMode);
  procedure SetTree(const Value: TActiveTree);
 protected
  procedure SetName(const Value: TComponentName); override;
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
 published
  property Mode:TTreeViewMode read FMode write SetMode default ViewAsTree;
  property Tree:TActiveTree read FTree write SetTree;
 End;
 //////////////////////////////////////////////////
implementation

uses Controls, MaskUtils;

{ TActiveNode }

procedure TActiveNode.Assign(Source: TPersistent);
Var
 src:TActiveNode;
begin
 if Source is TActiveNode then Begin
  Src:=TActiveNode(Source);
  FNodeType:=src.NodeType;
  FImageIndex:=src.ImageIndex;
  FLevel:=src.Level;
  FCaption:=src.Caption;
  FAction:=src.Action;
  FParent:=src.Parent;
  FChildren.assign(src.Children);
 End else inherited;
end;

procedure TActiveNode.SetAction(const Value: TAction);
begin
  FAction := Value;
end;

procedure TActiveNode.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TActiveNode.SetChildren(const Value: TActiveNodes);
begin
  FChildren := Value;
end;

procedure TActiveNode.SetImageIndex(const Value: integer);
begin
  FImageIndex := Value;
end;

procedure TActiveNode.SetIndex(const Value: integer);
begin
  FIndex := Value;
end;

procedure TActiveNode.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

procedure TActiveNode.SetNodeType(const Value: TNodeType);
begin
  FNodeType := Value;
end;

procedure TActiveNode.SetParent(const Value: TActiveNode);
begin
  FParent := Value;
end;

{ TActiveNodes }

function TActiveNodes.Add(Node: TActiveNode): integer;
begin
 Result:=MaxInd;
end;

procedure TActiveNodes.Assign(Source: TPersistent);
Var
 src:TActiveNodes;
 i:integer;
begin
 if Source is TActiveNodes then begin
  Clear;
  src:=TActiveNodes(Source);
  For i:=0 to src.Count-1 do add(src[i]);
 end else inherited;

end;

procedure TActiveNodes.Clear;
Var
 i:integer;
begin
 For i:=0 to MaxInd do FNodes[i].Free;
 MaxInd:=-1;
 SetLength(FNodes,0);
end;

procedure TActiveNodes.Delete(x: integer);
begin

end;

destructor TActiveNodes.Destroy;
begin
 SetLength(FNodes,0);
 inherited;
end;

function TActiveNodes.GetCount: integer;
begin
 result:=MaxInd+1;
end;

function TActiveNodes.GetNodes(x: integer): TActiveNode;
begin
 result:=nil;
end;

function TActiveNodes.Insert(X: integer; Node: TActiveNode): integer;
begin
 Result:=x;
end;

procedure TActiveNodes.SetLevel(const Value: integer);
begin
 FLevel := Value;
end;

procedure TActiveNodes.SetNodes(x: integer; const Value: TActiveNode);
begin
 if (x<0) or (x>MaxInd) then Exit;
 FNodes[x].assign(Value);
end;

{ TCustomActiveTree }

procedure TCustomActiveTree.Add(Node: TActiveNode);
begin

end;

procedure TCustomActiveTree.AddToList(cb: TComboEditX);
begin

end;

procedure TCustomActiveTree.AddToList(sts: TStrings; s: String);
begin

end;

procedure TCustomActiveTree.AddToList(sts: TStrings; Index: Integer);
begin

end;

procedure TCustomActiveTree.AddToList(cb: TComboBox);
begin

end;

procedure TCustomActiveTree.AddToList(ActList: TActionList;
  ACategory: String);
begin

end;

procedure TCustomActiveTree.AddToList(Acts: array of TAction);
begin

end;

procedure TCustomActiveTree.AddToList(gd: TNewGrid; Col, Row: integer);
begin

end;

constructor TCustomActiveTree.Create(AOwner: TComponent);
begin
 inherited;
 CurrentNode:=nil;
 FItems:=TActiveNodes.Create;
end;

procedure TCustomActiveTree.SetItems(const Value: TActiveNodes);
begin
 FItems := Value;
end;

{ TActiveTreeView }

constructor TActiveTreeView.Create(AOwner: TComponent);
begin
 inherited;
 FMode:=ViewAsList;
 FListView:=TListView.Create(self);
 With FListView do Begin
  ControlStyle:=ControlStyle+[csNoDesignVisible];
  Visible:=false;
  Align:=alClient;
  Parent:=self;
 End;
 FTreeView:=TTreeView.Create(self);
 With FTreeView do Begin
  ControlStyle:=ControlStyle+[csNoDesignVisible];
  Visible:=false;
  Align:=alClient;
  Parent:=self;
 End;
 Mode:=ViewAsTree;
 BevelOuter:=bvNone;
end;

destructor TActiveTreeView.Destroy;
begin
 inherited;
end;

procedure TActiveTreeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
 inherited;
 if (Operation=opRemove) and (AComponent=FTree) then FTree:=nil;
end;

procedure TActiveTreeView.SetMode(const Value: TTreeViewMode);
begin
 if FMode = Value Then Exit;
 FMode := Value;
 Case Value of
  ViewAsTree: Begin
   FTreeView.Visible:=true;
   FListView.Visible:=false;
  End;
  ViewAsList: Begin
   FListView.Visible:=true;
   FTreeView.Visible:=false;
  End;
 End;
end;

procedure TActiveTreeView.SetName(const Value: TComponentName);
begin
 inherited;
 Caption:='';
end;

procedure TActiveTreeView.SetTree(const Value: TActiveTree);
begin
 if FTree<>nil then FTree.RemoveFreeNotification(self);
 FTree := Value;
 if FTree<>nil then FTree.FreeNotification(self);
end;

end.
