dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.3.2.0.1579")
	{
		type(ForNav.Report; ForNavReport70210){}   
	}
	assembly("mscorlib")
	{
		Version='4.0.0.0';
		type("System.IO.Stream"; SystemIOStream70210){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 70210 "ForNAV Customer Payments"
{
	Caption = 'Customer Payments';
	WordLayout = './Layouts/ForNAV Customer Payments.docx'; DefaultLayout = Word;

	dataset
	{
		DataItem(CustLedgerEntry;"Cust. Ledger Entry")
		{
			CalcFields = "Remaining Amt. (LCY)","Amount (LCY)";
			DataItemTableView = sorting("Customer No.","Document Type","Posting Date") where("Document Type"=filter(Payment|"Credit Memo"));
			RequestFilterFields = "Posting Date","Global Dimension 1 Code","Global Dimension 2 Code","Salesperson Code","Customer No.";
			column(ReportForNavId_8503; 8503) {}
			DataItem(TempAppliedCustLedgEntry;"Cust. Ledger Entry")
			{
				CalcFields = "Original Amt. (LCY)","Amount (LCY)";
				DataItemTableView = sorting("Entry No.");
				UseTemporary = true;
				column(ReportForNavId_1000000000; 1000000000) {}
				trigger OnAfterGetRecord();
				begin
					CalcFields("Remaining Amt. (LCY)", "Amount (LCY)");
				end;
				
				trigger OnPreDataItem();
				begin
					SetFilter("Salesperson Code", SalespersonFilterString);
				end;
				
			}
			trigger OnAfterGetRecord();
			begin
				CalcFields("Amount (LCY)");
				GetAppliedCustEntries(CustLedgerEntry,true);
			end;
			
			trigger OnPreDataItem();
			begin
				SetRange("Salesperson Code");
			end;
			
		}
	}

	requestpage
	{
		SaveValues = true;

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
		Codeunit.Run(Codeunit::"ForNAV First Time Setup");
		Commit;
		LoadWatermark;
		;ReportForNav:= ReportForNav.Report(CurrReport.ObjectId, CurrReport.Language, SerialNumber, UserId, COMPANYNAME); ReportForNav.Init;
	end;


	trigger OnPostReport()
	begin
		ReportForNav.Post;
	end;


	trigger OnPreReport()
	begin
		SalespersonFilterString := CustLedgerEntry.GetFilter("Salesperson Code");
		;ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;if not ReportForNav.Pre then CurrReport.Quit;
	end;

	var
		SalespersonFilterString: Text;

	local procedure LoadWatermark()
	var
		ForNAVSetup: Record "ForNAV Setup";
		OutStream: OutStream;
	begin
		with ForNAVSetup do begin
		  Get;
		  CalcFields("List Report Watermark");
		  if not "List Report Watermark".Hasvalue then
			exit;
		  "List Report Watermark".CreateOutstream(OutStream);
		  ReportForNav.Watermark.Image.Load(OutStream);
		end;
	end;

	procedure GetAppliedCustEntries(CustLedgEntry: Record "Cust. Ledger Entry";UseLCY: Boolean)
	var
		DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
		PmtDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
		PmtCustLedgEntry: Record "Cust. Ledger Entry";
		ClosingCustLedgEntry: Record "Cust. Ledger Entry";
		AmountToApply: Decimal;
		AppliedDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
	begin
		TempAppliedCustLedgEntry.Reset;
		TempAppliedCustLedgEntry.DeleteAll;
		DtldCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.");
		DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
		DtldCustLedgEntry.SetRange(Unapplied,false);
		if DtldCustLedgEntry.Find('-') then
		  repeat
			if DtldCustLedgEntry."Cust. Ledger Entry No." = DtldCustLedgEntry."Applied Cust. Ledger Entry No." then begin
			  AppliedDtldCustLedgEntry.Init;
			  AppliedDtldCustLedgEntry.SetCurrentkey("Applied Cust. Ledger Entry No.","Entry Type");
			  AppliedDtldCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.",DtldCustLedgEntry."Applied Cust. Ledger Entry No.");
			  AppliedDtldCustLedgEntry.SetRange("Entry Type",AppliedDtldCustLedgEntry."entry type"::Application);
			  AppliedDtldCustLedgEntry.SetRange(Unapplied,false);
			  if AppliedDtldCustLedgEntry.Find('-') then
				repeat
				  if AppliedDtldCustLedgEntry."Cust. Ledger Entry No." <> AppliedDtldCustLedgEntry."Applied Cust. Ledger Entry No."
				  then begin
					if ClosingCustLedgEntry.Get(AppliedDtldCustLedgEntry."Cust. Ledger Entry No.") then begin
					  TempAppliedCustLedgEntry := ClosingCustLedgEntry;
					  if UseLCY then
						TempAppliedCustLedgEntry."Amount to Apply" := -AppliedDtldCustLedgEntry."Amount (LCY)"
					  else
						TempAppliedCustLedgEntry."Amount to Apply" := -AppliedDtldCustLedgEntry.Amount;
					  if TempAppliedCustLedgEntry.Insert then ;
					end;
				  end;
				until AppliedDtldCustLedgEntry.Next = 0;
			end else begin
			  if ClosingCustLedgEntry.Get(DtldCustLedgEntry."Applied Cust. Ledger Entry No.") then begin
				TempAppliedCustLedgEntry := ClosingCustLedgEntry;
				if UseLCY then
				  TempAppliedCustLedgEntry."Amount to Apply" := DtldCustLedgEntry."Amount (LCY)"
				else
				  TempAppliedCustLedgEntry."Amount to Apply" := DtldCustLedgEntry.Amount;
				if TempAppliedCustLedgEntry.Insert then ;
			  end;
			end;
		  until DtldCustLedgEntry.Next = 0;
		if CustLedgEntry."Closed by Entry No." <> 0 then begin
		  if ClosingCustLedgEntry.Get(CustLedgEntry."Closed by Entry No.") then begin
			TempAppliedCustLedgEntry := ClosingCustLedgEntry;
			if UseLCY then
			  TempAppliedCustLedgEntry."Amount to Apply" := -CustLedgEntry."Closed by Amount (LCY)"
			else
			  TempAppliedCustLedgEntry."Amount to Apply" := -CustLedgEntry."Closed by Amount";
			if TempAppliedCustLedgEntry.Insert then ;
		  end;
		end;
		ClosingCustLedgEntry.Reset;
		ClosingCustLedgEntry.SetCurrentkey("Closed by Entry No.");
		ClosingCustLedgEntry.SetRange("Closed by Entry No.",CustLedgEntry."Entry No.");
		if ClosingCustLedgEntry.Find('-') then
		  repeat
			TempAppliedCustLedgEntry := ClosingCustLedgEntry;
			if UseLCY then
			  TempAppliedCustLedgEntry."Amount to Apply" := ClosingCustLedgEntry."Closed by Amount (LCY)"
			else
			  TempAppliedCustLedgEntry."Amount to Apply" := ClosingCustLedgEntry."Closed by Amount";
			if TempAppliedCustLedgEntry.Insert then ;
		  until ClosingCustLedgEntry.Next = 0;
		if TempAppliedCustLedgEntry.IsEmpty then begin
		  TempAppliedCustLedgEntry.Init;
		  TempAppliedCustLedgEntry."Entry No." := 0;
		  TempAppliedCustLedgEntry."Salesperson Code" := CustLedgEntry."Salesperson Code";
		  TempAppliedCustLedgEntry.Insert;
		//  ApplicationExist := FALSE;
		end;
		// ELSE
		//  ApplicationExist := TRUE;
	end;
	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport70210;
		[RunOnClient]
		ReportForNavClient : DotNet ForNavReport70210;
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

	trigger ReportForNav::OnPrint(InStream : DotNet SystemIOStream70210);
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

	trigger ReportForNav::OnPrintPreview(InStream : DotNet SystemIOStream70210;Preview : Boolean);
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
			'CustLedgerEntry':
				with CustLedgerEntry do case Operation of
					'Add': begin
						ReportForNav.AddTotal(DataItemId,0,"Amount (LCY)");
						ReportForNav.AddTotal(DataItemId,1,"Remaining Amt. (LCY)");
					end;
					'Restore': begin
						"Amount (LCY)" := ReportForNav.RestoreTotal(DataItemId,0,GroupTotalFieldNo);
						"Remaining Amt. (LCY)" := ReportForNav.RestoreTotal(DataItemId,1,GroupTotalFieldNo);
					end;
				end;
			end;
	end;
	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
