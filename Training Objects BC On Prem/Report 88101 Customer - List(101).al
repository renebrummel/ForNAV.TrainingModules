dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.3.2.0.1579")
	{
		type(ForNav.Report; ForNavReport89101){}   
	}
	assembly("mscorlib")
	{
		Version='4.0.0.0';
		type("System.IO.Stream"; SystemIOStream89101){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 89101 "Customer - List(101)(88101)"
{
	Caption = 'Customer - List';
	WordLayout = './Layouts/Customer - List(101).docx'; DefaultLayout = Word;

	dataset
	{
		dataitem(Customer;Customer)
		{
			RequestFilterFields = "No.","Search Name","Customer Posting Group";
			column(ReportForNavId_6836; 6836) {}
			column(COMPANYNAME; CompanyProperty.DisplayName)
			{
			}
			column(CurrReport_PAGENO; ReportForNav_GetPageNo)
			{
			}
			column(Customer_TABLECAPTION__________CustFilter; TableCaption + ': ' + CustFilter)
			{
			}
			column(CustFilter; CustFilter)
			{
			}
			column(Customer__No__; "No.")
			{
			}
			column(Customer__Customer_Posting_Group_; "Customer Posting Group")
			{
			}
			column(Customer__Customer_Disc__Group_; "Customer Disc. Group")
			{
			}
			column(Customer__Invoice_Disc__Code_; "Invoice Disc. Code")
			{
			}
			column(Customer__Customer_Price_Group_; "Customer Price Group")
			{
			}
			column(Customer__Fin__Charge_Terms_Code_; "Fin. Charge Terms Code")
			{
			}
			column(Customer__Payment_Terms_Code_; "Payment Terms Code")
			{
			}
			column(Customer__Salesperson_Code_; "Salesperson Code")
			{
			}
			column(Customer__Currency_Code_; "Currency Code")
			{
			}
			column(Customer__Credit_Limit__LCY__; "Credit Limit (LCY)")
			{
				DecimalPlaces = 0:0;
			}
			column(Customer__Balance__LCY__; "Balance (LCY)")
			{
			}
			column(CustAddr_1_; CustAddr[1])
			{
			}
			column(CustAddr_2_; CustAddr[2])
			{
			}
			column(CustAddr_3_; CustAddr[3])
			{
			}
			column(CustAddr_4_; CustAddr[4])
			{
			}
			column(CustAddr_5_; CustAddr[5])
			{
			}
			column(Customer_Contact; Contact)
			{
			}
			column(Customer__Phone_No__; "Phone No.")
			{
			}
			column(CustAddr_6_; CustAddr[6])
			{
			}
			column(CustAddr_7_; CustAddr[7])
			{
			}
			column(Customer___ListCaption; Customer___ListCaptionLbl)
			{
			}
			column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
			{
			}
			column(Customer__No__Caption; FieldCaption("No."))
			{
			}
			column(Customer__Customer_Posting_Group_Caption; Customer__Customer_Posting_Group_CaptionLbl)
			{
			}
			column(Customer__Customer_Disc__Group_Caption; Customer__Customer_Disc__Group_CaptionLbl)
			{
			}
			column(Customer__Invoice_Disc__Code_Caption; Customer__Invoice_Disc__Code_CaptionLbl)
			{
			}
			column(Customer__Customer_Price_Group_Caption; Customer__Customer_Price_Group_CaptionLbl)
			{
			}
			column(Customer__Fin__Charge_Terms_Code_Caption; FieldCaption("Fin. Charge Terms Code"))
			{
			}
			column(Customer__Payment_Terms_Code_Caption; Customer__Payment_Terms_Code_CaptionLbl)
			{
			}
			column(Customer__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
			{
			}
			column(Customer__Currency_Code_Caption; Customer__Currency_Code_CaptionLbl)
			{
			}
			column(Customer__Credit_Limit__LCY__Caption; FieldCaption("Credit Limit (LCY)"))
			{
			}
			column(Customer__Balance__LCY__Caption; FieldCaption("Balance (LCY)"))
			{
			}
			column(Customer_ContactCaption; FieldCaption(Contact))
			{
			}
			column(Customer__Phone_No__Caption; FieldCaption("Phone No."))
			{
			}
			column(Total__LCY_Caption; Total__LCY_CaptionLbl)
			{
			}
			trigger OnAfterGetRecord();
			begin
				CalcFields("Balance (LCY)");
				FormatAddr.FormatAddr(
				  CustAddr,Name,"Name 2",'',Address,"Address 2",
				  City,"Post Code",County,"Country/Region Code");
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
		;ReportForNav:= ReportForNav.Report(CurrReport.ObjectId, CurrReport.Language, SerialNumber, UserId, COMPANYNAME); ReportForNav.Init;
	end;


	trigger OnPostReport()
	begin
		ReportForNav.Post;
	end;


	trigger OnPreReport()
	var
		CaptionManagement: Codeunit CaptionManagement;
	begin
		CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
		;ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;if not ReportForNav.Pre then CurrReport.Quit;
	end;

	var
		FormatAddr: Codeunit "Format Address";
		CustFilter: Text;
		CustAddr: array [8] of Text[50];
		Customer___ListCaptionLbl: label 'Customer - List';
		CurrReport_PAGENOCaptionLbl: label 'Page';
		Customer__Customer_Posting_Group_CaptionLbl: label 'Customer Posting Group';
		Customer__Customer_Disc__Group_CaptionLbl: label 'Cust./Item Disc. Gr.';
		Customer__Invoice_Disc__Code_CaptionLbl: label 'Invoice Disc. Code';
		Customer__Customer_Price_Group_CaptionLbl: label 'Price Group Code';
		Customer__Payment_Terms_Code_CaptionLbl: label 'Payment Terms Code';
		Customer__Currency_Code_CaptionLbl: label 'Currency Code';
		Total__LCY_CaptionLbl: label 'Total (LCY)';
	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport89101;
		[RunOnClient]
		ReportForNavClient : DotNet ForNavReport89101;
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

	trigger ReportForNav::OnPrint(InStream : DotNet SystemIOStream89101);
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

	trigger ReportForNav::OnPrintPreview(InStream : DotNet SystemIOStream89101;Preview : Boolean);
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
			'Customer':
				with Customer do case Operation of
					'Add': begin
						ReportForNav.AddTotal(DataItemId,0,"Balance (LCY)");
					end;
					'Restore': begin
						"Balance (LCY)" := ReportForNav.RestoreTotal(DataItemId,0,GroupTotalFieldNo);
					end;
				end;
			end;
	end;
	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
