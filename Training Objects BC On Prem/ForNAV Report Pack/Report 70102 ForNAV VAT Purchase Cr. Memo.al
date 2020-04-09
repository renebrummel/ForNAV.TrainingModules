dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.3.2.0.1579")
	{
		type(ForNav.Report; ForNavReport70102){}   
	}
	assembly("mscorlib")
	{
		Version='4.0.0.0';
		type("System.IO.Stream"; SystemIOStream70102){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 70102 "ForNAV VAT Purchase Cr. Memo"
{

	Caption = 'Purchase Credit Memo';
	WordLayout = './Layouts/ForNAV VAT Purchase Cr. Memo.docx'; DefaultLayout = Word;

	dataset
	{
		dataitem(Header;"Purch. Cr. Memo Hdr.")
		{
			CalcFields = "Amount Including VAT",Amount;
			DataItemTableView = sorting("No.");
			RequestFilterFields = "No.","Posting Date";
			column(ReportForNavId_2; 2) {}
			column(HasDiscount; ForNAVCheckDocumentDiscount.HasDiscount(Header))
			{
				IncludeCaption = false;
			}
			dataitem(Line;"Purch. Cr. Memo Line")
			{
				DataItemLink = "Document No."=field("No.");
				DataItemLinkReference = Header;
				DataItemTableView = sorting("Document No.","Line No.");
				column(ReportForNavId_3; 3) {}
			}
			dataitem(VATAmountLine;"VAT Amount Line")
			{
				DataItemTableView = sorting("VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",Positive);
				UseTemporary = true;
				column(ReportForNavId_1000000001; 1000000001) {}
				trigger OnPreDataItem();
				begin
					if not PrintVATAmountLines then
					  CurrReport.Break;
				end;
				
			}
			dataitem(VATClause;"VAT Clause")
			{
				DataItemTableView = sorting(Code);
				UseTemporary = true;
				column(ReportForNavId_1000000002; 1000000002) {}
			}
			trigger OnAfterGetRecord();
			begin
				
				ChangeLanguage("Language Code");
				GetVatAmountLines;
				GetVATClauses;
				UpdateNoPrinted;
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
					field(NoOfCopies;NoOfCopies)
					{
						ApplicationArea = Basic,Suite;
						Caption = 'No. of Copies';
					}
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
		;ReportForNav:= ReportForNav.Report(CurrReport.ObjectId, CurrReport.Language, SerialNumber, UserId, COMPANYNAME); ReportForNav.Init;
	end;


	trigger OnPostReport()
	begin
		ReportForNav.Post;
	end;


	trigger OnPreReport()
	begin
		ReportForNav.GetDataItem('Header').Copies := NoOfCopies;
		LoadWatermark;
		;ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;if not ReportForNav.Pre then CurrReport.Quit;
	end;

	var
		ForNAVCheckDocumentDiscount: Codeunit "ForNAV Check Document Discount";
		NoOfCopies: Integer;

	local procedure ChangeLanguage(LanguageCode: Code[10])
	var
		ForNAVSetup: Record "ForNAV Setup";
		Language: Record Language;
	begin
		ForNAVSetup.Get;
		if ForNAVSetup."Inherit Language Code" then
		  CurrReport.Language(Language.GetLanguageID(LanguageCode));
	end;

	local procedure GetVatAmountLines()
	var
		ForNAVGetVatAmountLines: Codeunit "ForNAV Get Vat Amount Lines";
	begin
		VATAmountLine.DeleteAll;
		ForNAVGetVatAmountLines.GetVatAmountLines(Header, VATAmountLine);
	end;

	local procedure GetVATClauses()
	var
		ForNAVGetVatClause: Codeunit "ForNAV Get Vat Clause";
	begin
		VATClause.DeleteAll;
		ForNAVGetVatClause.GetVATClauses(VATAmountLine, VATClause, Header."Language Code");
	end;

	local procedure PrintVATAmountLines(): Boolean
	var
		ForNAVSetup: Record "ForNAV Setup";
	begin
		with ForNAVSetup do begin
		  Get;
		  case "VAT Report Type" of
			"vat report type"::Always:
			  exit(true);
			"vat report type"::"Multiple Lines":
			  exit(VATAmountLine.Count > 1);
			"vat report type"::Never:
			  exit(false);
		  end;
		end;
	end;

	local procedure UpdateNoPrinted()
	var
		ForNAVUpdateNoPrinted: Codeunit "ForNAV Update No. Printed";
	begin
		ForNAVUpdateNoPrinted.UpdateNoPrinted(Header, CurrReport.Preview);
	end;

	local procedure LoadWatermark()
	var
		ForNAVSetup: Record "ForNAV Setup";
		OutStream: OutStream;
	begin
		with ForNAVSetup do begin
		  Get;
		  if not PrintLogo(ForNAVSetup) then
			exit;
		  CalcFields("Document Watermark");
		  if not "Document Watermark".Hasvalue then
			exit;
		  "Document Watermark".CreateOutstream(OutStream);
		  ReportForNav.Watermark.Image.Load(OutStream);
		end;
	end;

	procedure PrintLogo(ForNAVSetup: Record "ForNAV Setup"): Boolean
	begin
		if not ForNAVSetup."Use Preprinted Paper" then
		  exit(true);
		if ReportForNav.PrinterSettings.PrintTo = 'PDF' then
		  exit(true);
		if ReportForNav.PrinterSettings.PrintTo = 'Preview' then
		  exit(true);
		exit(false);
	end;
	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport70102;
		[RunOnClient]
		ReportForNavClient : DotNet ForNavReport70102;
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

	trigger ReportForNav::OnPrint(InStream : DotNet SystemIOStream70102);
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

	trigger ReportForNav::OnPrintPreview(InStream : DotNet SystemIOStream70102;Preview : Boolean);
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
			'Header':
				with Header do case Operation of
					'Add': begin
						ReportForNav.AddTotal(DataItemId,0,Amount);
						ReportForNav.AddTotal(DataItemId,1,"Amount Including VAT");
					end;
					'Restore': begin
						Amount := ReportForNav.RestoreTotal(DataItemId,0,GroupTotalFieldNo);
						"Amount Including VAT" := ReportForNav.RestoreTotal(DataItemId,1,GroupTotalFieldNo);
					end;
				end;
			'Line':
				with Line do case Operation of
					'Add': begin
						ReportForNav.AddTotal(DataItemId,0,Amount);
					end;
					'Restore': begin
						Amount := ReportForNav.RestoreTotal(DataItemId,0,GroupTotalFieldNo);
					end;
				end;
			'VATAmountLine':
				with VATAmountLine do case Operation of
					'Add': begin
						ReportForNav.AddTotal(DataItemId,0,"VAT %");
						ReportForNav.AddTotal(DataItemId,1,"Line Amount");
						ReportForNav.AddTotal(DataItemId,2,"VAT Amount");
						ReportForNav.AddTotal(DataItemId,3,"VAT Base");
					end;
					'Restore': begin
						"VAT %" := ReportForNav.RestoreTotal(DataItemId,0,GroupTotalFieldNo);
						"Line Amount" := ReportForNav.RestoreTotal(DataItemId,1,GroupTotalFieldNo);
						"VAT Amount" := ReportForNav.RestoreTotal(DataItemId,2,GroupTotalFieldNo);
						"VAT Base" := ReportForNav.RestoreTotal(DataItemId,3,GroupTotalFieldNo);
					end;
				end;
			end;
	end;
	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
