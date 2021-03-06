dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.4.1.0.1696")
	{
		type(ForNav.Report; ForNavReport55030){}   
	}
	assembly("mscorlib")
	{
		Version='4.0.0.0';
		type("System.IO.Stream"; SystemIOStream55030){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 55030 "ForNAV Sales Order"
{
	// Copyright (c) 2019 ForNAV ApS - All Rights Reserved
	// The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
	// Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
	// This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

	Caption = 'Sales Order';
	ApplicationArea = all;
	UsageCategory = ReportsandAnalysis;
	RDLCLayout = './Layouts/ForNAV Sales Order.rdlc'; DefaultLayout = RDLC;

	dataset
	{
		DataItem(Header;"Sales Header")
		{
			DataItemTableView = sorting("Document Type", "No.") where("Document Type" = CONST (Order));
			CalcFields = Amount;
			RequestFilterFields = "No.";
			column(ReportForNavId_2; 2) {}
			DataItem(Line;"Sales Line")
			{
				DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
				DataItemLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");
				column(ReportForNavId_3; 3) {}
				DataItem("Tracking Specification";"Tracking Specification")
				{
					UseTemporary = true;
					column(ReportForNavId_4; 4) {}
				}
				trigger OnAfterGetRecord();
				begin
					GetTrackingSpecification();
				end;
				
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
					field(ForNavOpenDesigner; ReportForNavOpenDesigner)
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
		;ReportsForNavInit;
	end;

	trigger OnPostReport()
	begin

		;ReportForNav.Post;

	end;

	trigger OnPreReport()
	begin
		;ReportsForNavPre;
	end;

	local procedure GetTrackingSpecification()
	var
		ForNAVGetTracking: Codeunit "ForNAV Get Tracking";
		RecRef: RecordRef;
	begin
		"Tracking Specification".DeleteAll();
		if Line.Type <> Line.Type::Item then
			exit;

		RecRef.GetTable(Line);
		ForNAVGetTracking.GetTrackingSpecification("Tracking Specification", RecRef);
	end;

	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport55030;
		[RunOnClient]
		ReportForNavClient : DotNet ForNavReport55030;
		ReportForNavDialog : Dialog;
		ReportForNavOpenDesigner : Boolean;
		[InDataSet]
		ReportForNavAllowDesign : Boolean;

	local procedure ReportsForNavInit();
	var
		fn : Text;
	begin
		fn := ApplicationPath + 'Add-ins\ReportsForNAV_4_1_0_1696\ForNav.Reports.4.1.0.1696.dll';
		if not File.Exists(fn) then
			Error('Please install the ForNAV DLL version 4.1.0.1696 in your service tier Add-ins folder under the file name "%1"', fn);
		ReportForNav:= ReportForNav.Report(CurrReport.OBJECTID, CurrReport.Language, SerialNumber, UserId, CompanyName);
		ReportForNav.Init;
	end;

	local procedure ReportsForNavPre();
	begin
		ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;
		if not ReportForNav.Pre then CurrReport.Quit;
	end;

	trigger ReportForNav::OnInit();
	begin
		ReportForNav.OData := GETURL(CLIENTTYPE::OData, CompanyName, OBJECTTYPE::Page, 7702);
		if ReportForNav.IsWindowsClient then begin
			ReportForNav.CheckClientAddIn();
			ReportForNavClient := ReportForNavClient.Report(ReportForNav.Definition);
			ReportForNavAllowDesign := ReportForNavClient.HasDesigner and not ReportForNav.ParameterMode;
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
		ReportID: Integer;
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		EmptyLayout := FORMAT(ReportLayoutSelection."Custom Report Layout Code");
		LayoutId := ReportLayoutSelection."Custom Report Layout Code";
		Evaluate(ReportID, Format(ReportForNav.ReportID));
		if ReportLayoutSelection.HasCustomLayout(ReportID) = 1 then begin
			if FORMAT(ReportLayoutSelection.GetTempLayoutSelected) <> EmptyLayout then begin
				LayoutId := ReportLayoutSelection.GetTempLayoutSelected;
			end else begin
				if ReportLayoutSelection.GET(ReportID, COMPANYNAME) then begin
					LayoutId := ReportLayoutSelection."Custom Report Layout Code";
				end;
			end;
		end else begin
			LayoutId := CustomReportLayout.GetDefaultCode(ReportID);
			CustomReportLayout.Init;
			CustomReportLayout.Code := LayoutId;
			CustomReportLayout."Report ID" := ReportID;
			CustomReportLayout.Description := 'ForNAV Custom Layout';
			CustomReportLayout.Type := CustomReportLayout.Type::RDLC;
			CustomReportLayout.Insert();
			if ReportLayoutSelection.GET(ReportID, COMPANYNAME) then begin
				ReportLayoutSelection.Type := ReportLayoutSelection.Type::"Custom Layout";
				ReportLayoutSelection."Custom Report Layout Code" := LayoutId;
				ReportLayoutSelection.Modify();
			end;
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

	trigger ReportForNav::OnPrint(InStream : DotNet SystemIOStream55030);
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

	trigger ReportForNav::OnPrintPreview(InStream : DotNet SystemIOStream55030;Preview : Boolean);
	var
		ClientFileName : Text[255];
	begin
		// This code is created automatically every time Reports ForNAV saves the report.
		// Do not modify this code.
		CurrReport.Language := System.GlobalLanguage;
		DownloadFromStream(InStream, '', '<TEMP>', '', ClientFileName);
		ReportForNavClient.PrintPreviewDialog(ClientFileName,ReportForNav.PrinterSettings.PrinterName,Preview);
	end;

	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
