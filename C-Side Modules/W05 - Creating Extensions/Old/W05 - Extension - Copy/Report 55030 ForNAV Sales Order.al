Report 55030 "ForNAV Sales Order"
{
    // Copyright (c) 2019 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

    Caption = 'Sales Order';
    WordLayout = './Layouts/ForNAV Sales Order.docx';
    DefaultLayout = Word;
    ApplicationArea = all;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        DataItem(Header; "Sales Header")
        {
            DataItemTableView = sorting ("Document Type", "No.") where ("Document Type" = CONST (Order));
            CalcFields = Amount;
            RequestFilterFields = "No.";
            column(ReportForNavId_2; 2) { }
            column(ReportForNav_Header; ReportForNavWriteDataItem('Header', Header)) { }
            DataItem(Line; "Sales Line")
            {
                DataItemTableView = sorting ("Document Type", "Document No.", "Line No.");
                DataItemLink = "Document No." = FIELD ("No."), "Document Type" = FIELD ("Document Type");
                column(ReportForNavId_3; 3) { }
                column(ReportForNav_Line; ReportForNavWriteDataItem('Line', Line)) { }
                DataItem("Tracking Specification"; "Tracking Specification")
                {
                    UseTemporary = true;
                    column(ReportForNavId_4; 4) { }
                    column(ReportForNav_TrackingSpecification; ReportForNavWriteDataItem('TrackingSpecification', "Tracking Specification")) { }
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
            'TrackingSpecification':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$TrackingSpecification$CurrentKey$Text', "Tracking Specification".CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
