unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Menus, StdCtrls, Buttons, ADODB,
  ComCtrls, ToolWin, ExtCtrls,
  inifiles,Dialogs,
  StrUtils, DB, ComObj,Variants,CPort, CoolTrayIcon;

type
  TfrmMain = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ADOConnection1: TADOConnection;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton8: TToolButton;
    ToolButton2: TToolButton;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    ToolButton5: TToolButton;
    ToolButton9: TToolButton;
    OpenDialog1: TOpenDialog;
    ComPort1: TComPort;
    ComDataPacket1: TComDataPacket;
    ToolButton7: TToolButton;
    SaveDialog1: TSaveDialog;
    LYTray1: TCoolTrayIcon;
    procedure N3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //增加病人信息表中记录,返回该记录的唯一编号作为检验结果表的外键
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: String);
    procedure ToolButton7Click(Sender: TObject);
    procedure ComPort1AfterOpen(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateConfig;{配置文件生效}
    function MakeDBConn:boolean;
    function GetSpecNo(const Value:string):string; //取得联机号
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses ucommfunction;

const
  CR=#$D+#$A;
  STX=#$2;ETX=#$3;ACK=#$6;NAK=#$15;
  sCryptSeed='lc';//加解密种子
  //SEPARATOR=#$1C;
  sCONNECTDEVELOP='错误!请与开发商联系!' ;
  IniSection='Setup';

var
  ConnectString:string;
  GroupName:string;//
  SpecStatus:string ;//
  CombinID:string;//
  LisFormCaption:string;//
  QuaContSpecNoG:string;
  QuaContSpecNo:string;
  QuaContSpecNoD:string;
  EquipChar:string;
  ifRecLog:boolean;//是否记录调试日志

  H_DTR_RTS:boolean;//DTR/RTS高电位
  EquipUnid:integer;//设备唯一编号
  No_Patient_ID:integer;//联机号位
  Len_Patient_ID:integer;//联机号长度
  No_Item_Data:integer;//数据项位
  Len_Item_Data:integer;//数据项长度
  Len_DtlStr:integer;//联机标识长度

  hnd:integer;
  bRegister:boolean;

{$R *.dfm}

function ifRegister:boolean;
var
  HDSn,RegisterNum,EnHDSn:string;
  configini:tinifile;
  pEnHDSn:Pchar;
begin
  result:=false;
  
  HDSn:=GetHDSn('C:\')+'-'+GetHDSn('D:\')+'-'+ChangeFileExt(ExtractFileName(Application.ExeName),'');

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));
  RegisterNum:=CONFIGINI.ReadString(IniSection,'RegisterNum','');
  CONFIGINI.Free;
  pEnHDSn:=EnCryptStr(Pchar(HDSn),sCryptSeed);
  EnHDSn:=StrPas(pEnHDSn);

  if Uppercase(EnHDSn)=Uppercase(RegisterNum) then result:=true;

  if not result then messagedlg('对不起,您没有注册或注册码错误,请注册!',mtinformation,[mbok],0);
end;

function GetConnectString:string;
var
  Ini:tinifile;
  userid, password, datasource, initialcatalog: string;
  ifIntegrated:boolean;//是否集成登录模式

  pInStr,pDeStr:Pchar;
  i:integer;
begin
  result:='';
  
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.INI'));
  datasource := Ini.ReadString('连接数据库', '服务器', '');
  initialcatalog := Ini.ReadString('连接数据库', '数据库', '');
  ifIntegrated:=ini.ReadBool('连接数据库','集成登录模式',false);
  userid := Ini.ReadString('连接数据库', '用户', '');
  password := Ini.ReadString('连接数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,sCryptSeed);
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  result := result + 'user id=' + UserID + ';';
  result := result + 'password=' + Password + ';';
  result := result + 'data source=' + datasource + ';';
  result := result + 'Initial Catalog=' + initialcatalog + ';';
  result := result + 'provider=' + 'SQLOLEDB.1' + ';';
  //Persist Security Info,表示ADO在数据库连接成功后是否保存密码信息
  //ADO缺省为True,ADO.net缺省为False
  //程序中会传ADOConnection信息给TADOLYQuery,故设置为True
  result := result + 'Persist Security Info=True;';
  if ifIntegrated then
    result := result + 'Integrated Security=SSPI;';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ComDataPacket1.StartString:=STX;
  ComDataPacket1.StopString:=ETX;

  ConnectString:=GetConnectString;
  UpdateConfig;
  if ifRegister then bRegister:=true else bRegister:=false;  

  Caption:='数据接收服务'+ExtractFileName(Application.ExeName);
  lytray1.Hint:='数据接收服务'+ExtractFileName(Application.ExeName);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caNone;
  LYTray1.HideMainForm;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  if (MessageDlg('退出后将不再接收设备数据,确定退出吗？', mtWarning, [mbYes, mbNo], 0) <> mrYes) then exit;
  application.Terminate;
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
  LYTray1.ShowMainForm;
end;

procedure TfrmMain.UpdateConfig;
var
  INI:tinifile;
  CommName,BaudRate,DataBit,StopBit,ParityBit:string;
  autorun:boolean;
begin
  ini:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  CommName:=ini.ReadString(IniSection,'串口选择','COM1');
  BaudRate:=ini.ReadString(IniSection,'波特率','9600');
  DataBit:=ini.ReadString(IniSection,'数据位','8');
  StopBit:=ini.ReadString(IniSection,'停止位','1');
  ParityBit:=ini.ReadString(IniSection,'校验位','None');
  H_DTR_RTS:=ini.readBool(IniSection,'DTR/RTS高电位',false);//Olympus:true,CA500/1500:false
  autorun:=ini.readBool(IniSection,'开机自动运行',false);
  ifRecLog:=ini.readBool(IniSection,'调试日志',false);

  GroupName:=trim(ini.ReadString(IniSection,'工作组',''));
  EquipChar:=trim(uppercase(ini.ReadString(IniSection,'仪器字母','')));//读出来是大写就万无一失了
  SpecStatus:=ini.ReadString(IniSection,'默认样本状态','');
  CombinID:=ini.ReadString(IniSection,'组合项目代码','');

  LisFormCaption:=ini.ReadString(IniSection,'检验系统窗体标题','');

  No_Patient_ID:=ini.ReadInteger(IniSection,'联机号位',10);//Olympus:10,CA-500:
  Len_Patient_ID:=ini.ReadInteger(IniSection,'联机号长度',4);//Olympus:4

  No_Item_Data:=ini.ReadInteger(IniSection,'数据项位',59);
  Len_Item_Data:=ini.ReadInteger(IniSection,'数据项长度',9);
  Len_DtlStr:=ini.ReadInteger(IniSection,'联机标识长度',3);

  EquipUnid:=ini.ReadInteger(IniSection,'设备唯一编号',-1);

  QuaContSpecNoG:=ini.ReadString(IniSection,'高值质控联机号','9999');
  QuaContSpecNo:=ini.ReadString(IniSection,'常值质控联机号','9998');
  QuaContSpecNoD:=ini.ReadString(IniSection,'低值质控联机号','9997');

  ini.Free;

  OperateLinkFile(application.ExeName,'\'+ChangeFileExt(ExtractFileName(Application.ExeName),'.lnk'),15,autorun);
  ComPort1.Close;
  ComPort1.Port:=CommName;
  if BaudRate='1200' then
    ComPort1.BaudRate:=br1200
    else if BaudRate='4800' then
      ComPort1.BaudRate:=br4800
      else if BaudRate='9600' then
        ComPort1.BaudRate:=br9600
        else if BaudRate='19200' then
          ComPort1.BaudRate:=br19200
          else ComPort1.BaudRate:=br9600;
  if DataBit='5' then
    ComPort1.DataBits:=dbFive
    else if DataBit='6' then
      ComPort1.DataBits:=dbSix
      else if DataBit='7' then
        ComPort1.DataBits:=dbSeven
        else if DataBit='8' then
          ComPort1.DataBits:=dbEight
          else ComPort1.DataBits:=dbEight;
  if StopBit='1' then
    ComPort1.StopBits:=sbOneStopBit
    else if StopBit='2' then
      ComPort1.StopBits:=sbTwoStopBits
      else if StopBit='1.5' then
        ComPort1.StopBits:=sbOne5StopBits
        else ComPort1.StopBits:=sbOneStopBit;
  if ParityBit='None' then
    ComPort1.Parity.Bits:=prNone
    else if ParityBit='Odd' then
      ComPort1.Parity.Bits:=prOdd
      else if ParityBit='Even' then
        ComPort1.Parity.Bits:=prEven
        else if ParityBit='Mark' then
          ComPort1.Parity.Bits:=prMark
          else if ParityBit='Space' then
            ComPort1.Parity.Bits:=prSpace
            else ComPort1.Parity.Bits:=prNone;
  try
    ComPort1.Open;
  except
    showmessage('串口'+ComPort1.Port+'打开失败!');
  end;
end;

function TfrmMain.GetSpecNo(const Value:string):string; //取得联机号
begin
    result:=copy(trim(Value),No_Patient_ID,Len_Patient_ID);
    result:='0000'+trim(result);
    result:=rightstr(result,4);
end;

function TfrmMain.MakeDBConn:boolean;
var
  newconnstr,ss: string;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  newconnstr := GetConnectString;
  try
    ADOConnection1.Connected := false;
    ADOConnection1.ConnectionString := newconnstr;
    ADOConnection1.Connected := true;
    result:=true;
  except
  end;
  if not result then
  begin
    ss:='服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '集成登录模式'+#2+'CheckListBox'+#2+#2+'0'+#2+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接数据库','连接数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure TfrmMain.ToolButton2Click(Sender: TObject);
var
  ss:string;
  lsComPort:TStrings;
  sComPort:String;
begin
  //获取串口列表 begin
  lsComPort := TStringList.Create;
  EnumComPorts(lsComPort);
  sComPort:=lsComPort.Text;
  lsComPort.Free;
  //获取串口列表 end

    ss:='串口选择'+#2+'Combobox'+#2+sComPort+#2+'0'+#2+#2+#3+
      '波特率'+#2+'Combobox'+#2+'19200'+#13+'9600'+#13+'4800'+#13+'2400'+#13+'1200'+#2+'0'+#2+#2+#3+
      '数据位'+#2+'Combobox'+#2+'8'+#13+'7'+#13+'6'+#13+'5'+#2+'0'+#2+#2+#3+
      '停止位'+#2+'Combobox'+#2+'1'+#13+'1.5'+#13+'2'+#2+'0'+#2+#2+#3+
      '校验位'+#2+'Combobox'+#2+'None'+#13+'Even'+#13+'Odd'+#13+'Mark'+#13+'Space'+#2+'0'+#2+#2+#3+
      'DTR/RTS高电位'+#2+'CheckListBox'+#2+#2+'0'+#2+'一般地,CA系列:不勾选;AU系列:勾选'+#2+#3+
      '工作组'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '仪器字母'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '检验系统窗体标题'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '默认样本状态'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '组合项目代码'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '开机自动运行'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '联机号位'+#2+'Edit'+#2+#2+'1'+#2+'不含0x2,从1开始,第几位.一般地,AU系列:10;CA系列查看文档Sample ID Number'+#2+#3+
      '联机号长度'+#2+'Edit'+#2+#2+'1'+#2+'从"联机号位"开始,取几位.一般地,AU系列:4;CA系列查看文档Sample ID Number'+#2+#3+
      '数据项位'+#2+'Edit'+#2+#2+'1'+#2+'不含0x2,从1开始,第几位.查看文档Data1、Data2...'+#2+#3+
      '数据项长度'+#2+'Edit'+#2+#2+'1'+#2+'一般地,CA系列:9;AU系列:10'+#2+#3+
      '联机标识长度'+#2+'Edit'+#2+#2+'1'+#2+'一般地,CA系统:3;AU系列:2'+#2+#3+
      '调试日志'+#2+'CheckListBox'+#2+#2+'0'+#2+'注:强烈建议在正常运行时关闭'+#2+#3+
      '设备唯一编号'+#2+'Edit'+#2+#2+'1'+#2+#2+#3+
      '高值质控联机号'+#2+'Edit'+#2+#2+'2'+#2+#2+#3+
      '常值质控联机号'+#2+'Edit'+#2+#2+'2'+#2+#2+#3+
      '低值质控联机号'+#2+'Edit'+#2+#2+'2'+#2+#2;

  if ShowOptionForm('',Pchar(IniSection),Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
	  UpdateConfig;
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  SaveDialog1.DefaultExt := '.txt';
  SaveDialog1.Filter := 'txt (*.txt)|*.txt';
  if not SaveDialog1.Execute then exit;
  memo1.Lines.SaveToFile(SaveDialog1.FileName);
  showmessage('保存成功!');
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  ls:Tstrings;
begin
  OpenDialog1.DefaultExt := '.txt';
  OpenDialog1.Filter := 'txt (*.txt)|*.txt';
  if not OpenDialog1.Execute then exit;
  ls:=Tstringlist.Create;
  ls.LoadFromFile(OpenDialog1.FileName);
  ComDataPacket1Packet(nil,ls.Text);
  ls.Free;
end;

procedure TfrmMain.ToolButton5Click(Sender: TObject);
var
  ss:string;
begin
  ss:='RegisterNum'+#2+'Edit'+#2+#2+'0'+#2+'将该窗体标题栏上的字符串发给开发者,以获取注册码'+#2;
  if bRegister then exit;
  if ShowOptionForm(Pchar('注册:'+GetHDSn('C:\')+'-'+GetHDSn('D:\')+'-'+ChangeFileExt(ExtractFileName(Application.ExeName),'')),Pchar(IniSection),Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
    if ifRegister then bRegister:=true else bRegister:=false;
end;

procedure TfrmMain.ComDataPacket1Packet(Sender: TObject; const Str: String);
VAR
  SpecNo:string;
  i:integer;
  dlttype:string;
  sValue:string;
  //FInts:IData2Lis;
  FInts:OleVariant;
  ReceiveItemInfo:OleVariant;
  rfm2:string;
  CheckDate:string;
  SpecType:string ;
begin
  //20100602发现,Olympus传过来的数据有可能#$2#$2'D...',故需Trim

  memo1.Lines.Add(Str);

  if length(Str)<=11 then exit;//Olympus:#$2DB#$3,#$2DE#$3

  if(leftstr(trim(Str),1)='D')//CA、AU系列,检验结果 Analyzer->host
   or((length(trim(Str))>0)and(trim(Str)[1] in [':','1','2','3','4','5','6','7','8','9']))THEN//日立7180
  BEGIN
    SpecNo:=GetSpecNo(Str);
    CheckDate:='20'+copy(trim(Str),14,2)+'-'+copy(trim(Str),10,2)+'-'+copy(trim(Str),12,2)+' '+copy(trim(Str),16,2)+':'+copy(trim(Str),18,2)+':00';//AU无检查时间信息.Data2Lis会将无效时间转变为当前时间
    if(length(trim(Str))>0)and(trim(Str)[1] in [':','1','2','3','4','5','6','7','8','9'])then
      CheckDate:='20'+copy(trim(Str),36,2)+'-'+copy(trim(Str),32,2)+'-'+copy(trim(Str),34,2)+' '+copy(trim(Str),38,2)+':'+copy(trim(Str),40,2)+':00';//日立7180
    if copy(trim(Str),9,1)=' ' then SpecType:='血浆' else if copy(trim(Str),9,1)='U' then SpecType:='尿液' else SpecType:='血浆';

    rfm2:=copy(TrimLeft(Str),No_Item_Data,MaxInt);
    ReceiveItemInfo:=VarArrayCreate([0,(length(rfm2) div Len_Item_Data)-1],varVariant);
    i:=0;
    while length(rfm2)>=Len_Item_Data do
    begin
      dlttype:=trim(leftstr(rfm2,Len_DtlStr));
      sValue:=trim(copy(rfm2,Len_DtlStr+1,Len_Item_Data-Len_DtlStr));
      sValue:=StringReplace(sValue,'e','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'r','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'*','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'H','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'L','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'G','',[rfReplaceAll, rfIgnoreCase]);//AU400
      sValue:=StringReplace(sValue,'!','',[rfReplaceAll, rfIgnoreCase]);//日立7180
      sValue:=StringReplace(sValue,'V','',[rfReplaceAll, rfIgnoreCase]);//日立7180
      ReceiveItemInfo[i]:=VarArrayof([dlttype,sValue,'','']);
      inc(i);
      delete(rfm2,1,Len_Item_Data);
    end;

    if bRegister then
    begin
      //FInts :=CoData2Lis.CreateRemote('');//暂时仅支持本机
      FInts :=CreateOleObject('Data2LisSvr.Data2Lis');
      FInts.fData2Lis(ReceiveItemInfo,(SpecNo),CheckDate,
        (GroupName),(SpecType),(SpecStatus),(EquipChar),
        (CombinID),'',(LisFormCaption),(ConnectString),
        (QuaContSpecNoG),(QuaContSpecNo),(QuaContSpecNoD),'',
        ifRecLog,true,'常规',
        trim(copy(trim(Str),No_Patient_ID,Len_Patient_ID)),
        EquipUnid,
        '','','','',
        -1,-1,-1,-1,
        -1,-1,-1,-1,
        false,false,false,false);
      //if FInts<>nil then FInts:=nil;
      if not VarIsEmpty(FInts) then FInts:= unAssigned;
    end;
  END;

  {if copy(str,2,1)='R' THEN//查询 Analyzer(CA-500/1500)->host
  BEGIN
    OrderInfoHeader:=STX;
    OrderInfoHeader:=OrderInfoHeader+'S';
    OrderInfoHeader:=OrderInfoHeader+copy(Str,3,7);
    OrderInfoHeader:=OrderInfoHeader+'U';
    OrderInfoHeader:=OrderInfoHeader+copy(Str,11,10+RackNumber+2+SampleIDNumber+1+PatientName);
    
    rSampleIDNumber:=trim(copy(Str,20+RackNumber+2+1,SampleIDNumber));

    //根据条码获取病人联机标识列表
    pList:=GetEquipIdList(pchar(ConnectString),pchar(rSampleIDNumber),pchar(EquipChar));
    sList:=TStringList.Create;
    ExtractStrings([#2],[],pList,sList);
    for j :=0  to sList.Count-1 do
    begin
      AnalysisParamData:=AnalysisParamData+rightstr(StringOfChar(#$20,3)+sList[j],3)+StringOfChar(#$20,6);//#$20#$20#$20#$20#$20#$20;
    end;
    sList.Free;

    //exit;
    //if not GetEquipIdList(pchar(ConnectString),pchar(rSampleIDNumber),pchar(EquipChar),aryEquipId) then
    //begin
    //  memo1.Lines.Add('条码号:'+rSampleIDNumber+',联机字母:'+EquipChar+',获取病人联机标识列表失败');
    //  exit;
    //end;

    OrderInfoSend:=OrderInfoHeader+AnalysisParamData+ETX;
    if ComPort1.WriteStr(OrderInfoSend)<=0 then
    begin
      memo1.Lines.Add('向仪器发送指令失败:'+OrderInfoSend);
    end;
  end;//}

  {if copy(str,1,1)='R' THEN//AU->HOST 查询
  BEGIN
    exit;
    OrderInfoHeader:=STX;
    OrderInfoHeader:=OrderInfoHeader+'S';
    OrderInfoHeader:=OrderInfoHeader+copy(Str,3,7);
    OrderInfoHeader:=OrderInfoHeader+'U';
    OrderInfoHeader:=OrderInfoHeader+copy(Str,11,10+RackNumber+2+SampleIDNumber+1+PatientName);
    
    rSampleIDNumber:=trim(copy(Str,20+RackNumber+2+1,SampleIDNumber));

    //根据条码获取病人联机标识列表
    pList:=GetEquipIdList(pchar(ConnectString),pchar(rSampleIDNumber),pchar(EquipChar));
    sList:=TStringList.Create;
    ExtractStrings([#2],[],pList,sList);
    for j :=0  to sList.Count-1 do
    begin
      AnalysisParamData:=AnalysisParamData+rightstr(StringOfChar(#$20,3)+sList[j],3)+StringOfChar(#$20,6);//#$20#$20#$20#$20#$20#$20;
    end;
    sList.Free;

    //exit;
    //if not GetEquipIdList(pchar(ConnectString),pchar(rSampleIDNumber),pchar(EquipChar),aryEquipId) then
    //begin
    //  memo1.Lines.Add('条码号:'+rSampleIDNumber+',联机字母:'+EquipChar+',获取病人联机标识列表失败');
    //  exit;
    //end;

    OrderInfoSend:=OrderInfoHeader+AnalysisParamData+ETX;
    if ComPort1.WriteStr(OrderInfoSend)<=0 then
    begin
      memo1.Lines.Add('向仪器发送指令失败:'+OrderInfoSend);
    end;
    
    exit;
    sSendCmdHead:=copy(str,1,34);//34待定
    //通过样本号找优先级别:常规、急诊等
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:='select Diagnosetype from chk_con_his where lsh='''+SpecNo+''' ';
    adotemp11.Open;
    sYXJB:=sSendCmd+adotemp11.fieldbyname('itemid').AsString;
    adotemp11.Free;
    //====================
    if sYXJB='急诊' then sSendCmdHead[11]:='P'; 
    sSendCmdHead:=stringreplace(sSendCmdHead,#2+'RH',#2+'R ',[]);//不管是否重做查询，都发正常指令
    sSendCmd:=sSendCmdHead+'    ';//4个空格，dummy
    sSendCmd:=sSendCmd+'E';//Block Indentification No.
    sSendCmd:=sSendCmd+'0';//Sex
    sSendCmd:=sSendCmd+'   ';//Age,3个空格
    sSendCmd:=sSendCmd+'  ';//Month,2个空格
    //通过样本号找检验项目
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:='select cci.itemid from chk_con_his cn,chk_valu_his cv,combinitem cbi,CombSChkItem csi,clinicchkitem cci '+
                        'where cn.unid=cv.pkunid and cn.lsh='''+SpecNo+''' and cv.pkcombin_id=cbi.id '+
                        'and cbi.unid=csi.CombUnid and csi.ItemUnid=cci.unid and cci.commword='''+EquipChar+''' '+
                        'group by cci.itemid';
    adotemp11.Open;
    while not adotemp11.Eof do
    begin
      sSendCmd:=sSendCmd+adotemp11.fieldbyname('itemid').AsString;//检验项目
      adotemp11.Next;
    end;
    adotemp11.Free;
    //====================
    sSendCmd:=sSendCmd+#3;
    ComPort1.WriteStr(sSendCmd);//HOST->AU 请求指令
  END;//}  
end;

procedure TfrmMain.ToolButton7Click(Sender: TObject);
begin
  if MakeDBConn then ConnectString:=GetConnectString;
end;

procedure TfrmMain.ComPort1AfterOpen(Sender: TObject);
begin
  if H_DTR_RTS then
  begin
    ComPort1.SetDTR(true);
    ComPort1.SetRTS(true);
  end;
end;

procedure TfrmMain.Memo1Change(Sender: TObject);
begin
  if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
end;

initialization
    hnd := CreateMutex(nil, True, Pchar(ExtractFileName(Application.ExeName)));
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
        MessageBox(application.Handle,pchar('该程序已在运行中！'),
                    '系统提示',MB_OK+MB_ICONinformation);   
        Halt;
    end;

finalization
    if hnd <> 0 then CloseHandle(hnd);

end.
