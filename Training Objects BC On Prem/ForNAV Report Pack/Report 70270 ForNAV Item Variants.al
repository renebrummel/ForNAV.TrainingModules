dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.3.2.0.1579")
	{
		type(ForNav.Report; ForNavReport70270){}   
	}
	assembly("mscorlib")
	{
		Version='4.0.0.0';
		type("System.IO.Stream"; SystemIOStream70270){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 70270 "ForNAV Item Variants"
{
	Caption = 'Item Variants';
	WordLayout = './Layouts/ForNAV Item Variants.docx'; DefaultLayout = Word;

	dataset
	{
		dataitem(Item;Item)
		{
			DataItemTableView = sorting("Inventory Posting Group");
			column(ReportForNavId_1000000000; 1000000000) {}
			column(HTMLTable; HTMLTable)
			{
				IncludeCaption = false;
			}
			column(Color; GetColor)
			{
				IncludeCaption = false;
			}
		}
	}

	requestpage
	{

		layout
		{
			area(content)
			{
				group(Options)
				{
					Caption = 'Options';
					field(ForNavOpenDesigner;ReportForNavOpenDesigner)
					{
						ApplicationArea = Basic;
						Caption = 'Design';
						Visible = ReportForNavAllowDesign;
					}
				}
			}
		}

		actions
		{
		}
	}

	trigger OnInitReport()
	begin
		;ReportForNav:= ReportForNav.Report(CurrReport.ObjectId, CurrReport.Language, SerialNumber, UserId, COMPANYNAME); ReportForNav.Init;
	end;


	trigger OnPostReport()
	begin
		ReportForNav.Post;
	end;


	trigger OnPreReport()
	begin
		;ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;if not ReportForNav.Pre then CurrReport.Quit;
	end;


	local procedure HTMLTable(): Text
	begin
		exit('<!DOCTYPE>' +
		'<html>'+
		'<head>'+
		GetStyle+
		'</head>'+
		'<body>'+
		'<table style="margin-left: 10px">'+
		'  <tr>'+
		'	<th>Color</th>'+
		'	<th>QTY</th>'+
		'  </tr>'+
		GetTableRows+
		'</table>'+
		'</body>'+
		'</html>');
	end;

	local procedure GetTableRows(): Text
	var
		ItemVariant: Record "Item Variant";
		HTMLTable: Text;
	begin
		ItemVariant.SetRange("Item No.", Item."No.");
		if ItemVariant.FindSet then repeat
		  HTMLTable += '<tr>';
		  HTMLTable += '<td>' + ItemVariant.Code+ '</td>';
		  HTMLTable += '<td>' + Format(ItemVariant.Description) + '</td>';
		  HTMLTable += '</tr>';
		until ItemVariant.Next = 0;
		exit(HTMLTable);
	end;

	local procedure GetStyle(): Text
	begin
		exit('<style>' +
			 'table, th, td {'+
			 'border: 1px solid black;'+
			 'font-family: segoe ui;'+
			 'font-size: 10px;'+
			 '}'+
			 '</style>');
	end;

	local procedure GetColor(): Text
	begin
		exit(GetDemoColorFromPostingGroup(Item."Inventory Posting Group"));
	end;

	local procedure GetDemoColorFromPostingGroup(Value: Code[10]): Text
	var
		InventoryPostingGroup: Record "Inventory Posting Group";
		i: Integer;
	begin
		if InventoryPostingGroup.FindSet then repeat
		  i += 1;
		until (InventoryPostingGroup.Code = Value) or (InventoryPostingGroup.Next = 0);
		case i of
		  1: exit('BurlyWood');
		  2: exit('DeepSkyBlue');
		  3: exit('LightGreen');
		  4: exit('LightPink');
		end;
	end;
	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport70270;
		[RunOnClient]
		ReportForNavClient : DotNet ForNavReport70270;
		ReportForNavDialog : Dialog;
		ReportForNavOpenDesigner : Boolean;
		[InDataSet]
		ReportForNavAllowDesign : Boolean;

	trigger ReportForNav::OnInit();
	begin
		if ReportForNav.IsWindowsClient then begin
			ReportForNav.CheckClientAddIn();
			ReportForNavClient := ReportForNavClient.Report(ReportForNav.Definition);
			ReportForNavAllowDesign := ReportForNavClient.HasDesigner AND NOT ReportForNav.ParameterMode;
		end;
	end;

	trigger ReportForNav::OnSave(Base64Layout : Text);
	var
		CustomReportLayout : Record "Custom Report Layout";
		ReportLayoutSelection : Record "Report Layout Selection";
		LayoutId : Variant;
		TempBlob : Record TempBlob;
		OutStream : OutStream;
		Bstr : BigText;
		EmptyLayout : Text;
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		EmptyLayout := FORMAT(ReportLayoutSelection."Custom Report Layout Code");
		LayoutId := ReportLayoutSelection."Custom Report Layout Code";
		if ReportLayoutSelection.HasCustomLayout(ReportForNav.ReportID) = 1 then begin
			if FORMAT(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then begin
				LayoutId := ReportLayoutSelection.GetTempLayoutSelected;
			end else begin
			if ReportLayoutSelection.GET(ReportForNav.ReportID, COMPANYNAME) then begin
				LayoutId := ReportLayoutSelection."Custom Report Layout Code";
			end;
		end;
		end else begin
			if CONFIRM('Default custom layout not found. Create one?') then;
		end;
		if FORMAT(LayoutId) <> EmptyLayout then begin
			TempBlob.Blob.CREATEOUTSTREAM(OutStream);
			Bstr.ADDTEXT(Base64Layout);
			Bstr.WRITE(OutStream);
			CustomReportLayout.GET(LayoutId);
			CustomReportLayout.ImportLayoutBlob(TempBlob, 'RDL');
		end;
	end;

	trigger ReportForNav::OnParameters(Parameters : Text);
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		ReportForNav.Parameters := REPORT.RUNREQUESTPAGE(ReportForNav.ReportID, Parameters);
	end;

	trigger ReportForNav::OnPreview(Parameters : Text;FileName : Text);
	var
		PdfFile : File;
		InStream : InStream;
		OutStream : OutStream;
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		COMMIT;
		PdfFile.CREATETEMPFILE;
		PdfFile.CREATEOUTSTREAM(OutStream);
		REPORT.SAVEAS(ReportForNav.ReportID, Parameters, REPORTFORMAT::Pdf, OutStream);
		PdfFile.CREATEINSTREAM(InStream);
		ReportForNavClient.ShowDesigner;
		if ReportForNav.IsValidPdf(PdfFile.NAME) then DOWNLOADFROMSTREAM(InStream, '', '', '', FileName);
		PdfFile.CLOSE;
	end;

	trigger ReportForNav::OnSelectPrinter();
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		ReportForNav.PrinterSettings.PageSettings := ReportForNavClient.SelectPrinter(ReportForNav.PrinterSettings.PrinterName,ReportForNav.PrinterSettings.ShowPrinterDialog,ReportForNav.PrinterSettings.PageSettings);
	end;

	trigger ReportForNav::OnPrint(InStream : DotNet SystemIOStream70270);
	var
		ClientFileName : Text[255];
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		DOWNLOADFROMSTREAM(InStream, '', '<TEMP>', '', ClientFileName);
		ReportForNavClient.Print(ClientFileName); 
	end;

	trigger ReportForNav::OnDesign(Data : Text);
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		ReportForNavClient.Data := Data;
		while ReportForNavClient.DesignReport do begin
			ReportForNav.HandleRequest(ReportForNavClient.GetRequest());
			SLEEP(100);
		end;
	end;

	trigger ReportForNav::OnView(ClientFileName : Text;Parameters : Text;ServerFileName : Text);
	var
		ServerFile : File;
		ServerInStream : InStream;
		"Filter" : Text;
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		ServerFile.OPEN(ServerFileName);
		ServerFile.CREATEINSTREAM(ServerInStream);
		if STRLEN(ClientFileName) >= 4 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName)-3, 4)) = '.pdf' then Filter := 'PDF (*.pdf)|*.pdf';
		if STRLEN(ClientFileName) >= 4 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName)-3, 4)) = '.doc' then Filter := 'Microsoft Word (*.doc)|*.doc';
		if STRLEN(ClientFileName) >= 5 then if LOWERCASE(COPYSTR(ClientFileName, STRLEN(ClientFileName)-4, 5)) = '.xlsx' then Filter := 'Microsoft Excel (*.xlsx)|*.xlsx';
		DOWNLOADFROMSTREAM(ServerInStream,'Export','',Filter,ClientFileName);
	end;

	trigger ReportForNav::OnMessage(Operation : Text;Parameter : Text;ParameterNo : Integer);
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		case Operation of
			'Open'	: ReportForNavDialog.Open(Parameter);
			'Update'  : ReportForNavDialog.Update(ParameterNo,Parameter);
			'Close'   : ReportForNavDialog.Close();
			'Message' : Message(Parameter);
			'Error'   : Error(Parameter);
		end;
	end;

	trigger ReportForNav::OnPrintPreview(InStream : DotNet SystemIOStream70270;Preview : Boolean);
	var
		ClientFileName : Text[255];
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		CurrReport.Language := System.GlobalLanguage;
		DownloadFromStream(InStream, '', '<TEMP>', '', ClientFileName);
		ReportForNavClient.PrintPreviewDialog(ClientFileName,ReportForNav.PrinterSettings.PrinterName,Preview);
	end;

	trigger ReportForNav::OnGetWordLayout(reportNo: Integer)
	var
		layoutStream : InStream;
		zip: Codeunit "Zip Stream Wrapper";
		oStream: OutStream;
		iStream: InStream;
		layout: Text;
		dataContract: Text;
		tempBlob: Record "TempBlob";
		ReportLayoutSelection: Record "Report Layout Selection";
		CustomReportLayout: Record "Custom Report Layout";
		CustomLayoutID: Variant;
		EmptyLayout: Text;
		props: XmlDocument;
		prop: XmlNode;
		layoutNode: XmlNode;
	begin
		EmptyLayout := FORMAT(ReportLayoutSelection."Custom Report Layout Code");
		CustomLayoutID := ReportLayoutSelection."Custom Report Layout Code";
		if Format(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then
			CustomLayoutID := ReportLayoutSelection.GetTempLayoutSelected
		else
			if ReportLayoutSelection.HasCustomLayout(reportNo) = 2 then
				CustomLayoutID := ReportLayoutSelection."Custom Report Layout Code";

		if (Format(CustomLayoutID) <> EmptyLayout) AND CustomReportLayout.GET(CustomLayoutID) then begin
			CustomReportLayout.TestField(Type, CustomReportLayout.Type::Word);
			CustomReportLayout.CalcFields(Layout);
			CustomReportLayout.Layout.CreateInstream(layoutStream, TEXTENCODING::UTF8);
		end else
			Report.WordLayout(reportNo, layoutStream);
		zip.OpenZipFromStream(layoutStream, false);
		tempBlob.Blob.CreateOutStream(oStream);
		zip.WriteEntryFromZipToOutStream('docProps/custom.xml', oStream);
		tempBlob.Blob.CreateInStream(iStream);
		XmlDocument.ReadFrom(iStream, props);
		props.GetChildNodes().Get(1, prop);
		prop.AsXmlElement().GetChildNodes().Get(1, layoutNode);
		layout := layoutNode.AsXmlElement().InnerText();
		ReportForNav.WordLayout := layout;
	end;
	procedure ReportForNav_GetPageNo() : Integer
	begin
		exit(ReportForNav.PageNo);
	end;

	trigger ReportForNav::OnTotals(DataItemId: Text; Operation: Text; GroupTotalFieldNo: Integer)
	begin
		// Do not change (Autogenerated by Reports ForNAV) - Instead change the Create Totals, Total Fields or Group Total Fields properties on the Data item in the ForNAV designer
		case DataItemId of
			'Item':
				with Item do case Operation of
				end;
			end;
	end;
	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
