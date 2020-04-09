Report 89010 "ForNAV W04 JavaScript"
{
    // Copyright (c) 2019 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

    Caption = 'W04 JavaScript';
    WordLayout = '.\Layouts\ForNAV W04 JavaScript.docx';
    DefaultLayout = Word;
    ApplicationArea = all;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(ReportForNavId_2; 2) { }
            column(ReportForNav_Header; ReportForNavWriteDataItem('Header', Header)) { }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemTableView = sorting ("Document No.", Type);
                DataItemLinkReference = Header;
                DataItemLink = "Document No." = FIELD ("No.");
                column(ReportForNavId_3; 3) { }
                column(ReportForNav_Line; ReportForNavWriteDataItem('Line', Line)) { }
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting ("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(ReportForNavId_4; 4) { }
                column(ReportForNav_VATAmountLine; ReportForNavWriteDataItem('VATAmountLine', VATAmountLine)) { }
            }
            dataitem(VATClause; "VAT Clause")
            {
                UseTemporary = true;
                column(ReportForNavId_5; 5) { }
                column(ReportForNav_VATClause; ReportForNavWriteDataItem('VATClause', VATClause)) { }
            }
            trigger OnAfterGetRecord();
            begin
                ChangeLanguage("Language Code");
                GetVatAmountLines;
                GetVATClauses;
            end;

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
        ;
        ReportsForNavInit;
    end;

    trigger OnPostReport()
    begin





    end;

    trigger OnPreReport()
    begin
        ;
        ReportsForNavPre;
    end;

    local procedure ChangeLanguage(LanguageCode: Code[10])
    var
        Language: Record Language;
    begin
        CurrReport.Language(Language.GetLanguageID(LanguageCode));
    end;

    local procedure GetVatAmountLines()
    var
        ForNAVGetVatAmountLines: Codeunit "ForNAV Get Vat Amount Lines";
    begin
        VatAmountLine.DeleteAll;
        ForNAVGetVatAmountLines.GetVatAmountLines(Header, VatAmountLine);
    end;

    local procedure GetVATClauses()
    var
        ForNAVGetVatClause: Codeunit "ForNAV Get Vat Clause";
    begin
        VATClause.DeleteAll;
        ForNAVGetVatClause.GetVATClauses(VatAmountLine, VATClause, Header."Language Code");
    end;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        ReportForNavInitialized: Boolean;
        ReportForNavShowOutput: Boolean;
        ReportForNavTotalsCausedBy: Boolean;
        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;
        ReportForNav: Codeunit "ForNAV Report Management";

    local procedure ReportsForNavInit()
    var
        id: Integer;
    begin
        Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1));
        ReportForNav.OnInit(id, ReportForNavAllowDesign);
    end;

    local procedure ReportsForNavPre()
    begin
        if ReportForNav.LaunchDesigner(ReportForNavOpenDesigner) then CurrReport.Quit();
    end;

    local procedure ReportForNavSetTotalsCausedBy(value: Boolean)
    begin
        ReportForNavTotalsCausedBy := value;
    end;

    local procedure ReportForNavSetShowOutput(value: Boolean)
    begin
        ReportForNavShowOutput := value;
    end;

    local procedure ReportForNavInit(jsonObject: JsonObject)
    begin
        ReportForNav.Init(jsonObject, CurrReport.ObjectId);
    end;

    local procedure ReportForNavWriteDataItem(dataItemId: Text; rec: Variant): Text
    var
        values: Text;
        jsonObject: JsonObject;
        currLanguage: Integer;
    begin
        if not ReportForNavInitialized then begin
            ReportForNavInit(jsonObject);
            ReportForNavInitialized := true;
        end;

        case (dataItemId) of
            'Header':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$Header$CurrentKey$Text', Header.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
            'VATClause':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$VATClause$CurrentKey$Text', VATClause.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
