codeunit 56000 "ForNAV Get Tracking"
{
    // Copyright (c) 2019 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

    procedure GetTrackingSpecification(var TrackingSpecification: Record "Tracking Specification"; RecRef: RecordRef)
    begin
        case RecRef.Number of
            Database::"Sales Line",
            Database::"Purchase Line":
                begin
                    GetReservationEntries(TrackingSpecification, RecRef);
                    GetItemLedgerEntries(TrackingSpecification, RecRef);
                end;
            Database::"Sales Invoice Line",
            Database::"Purch. Inv. Line",
            Database::"Sales Shipment Line",
            Database::"Purch. Rcpt. Line":
                GetItemLedgerEntries(TrackingSpecification, RecRef);
        end;
    end;

    local procedure GetReservationEntries(var TrackingSpecification: Record "Tracking Specification"; RecRef: RecordRef)
    var
        ReservationEntry: Record "Reservation Entry";
        FldRef: FieldRef;
    begin
        FldRef := RecRef.Field(3); // Document No
        ReservationEntry.SetRange("Source ID", FldRef.Value);
        FldRef := RecRef.Field(4); // Line No
        ReservationEntry.SetRange("Source Ref. No.", FldRef.Value);
        FldRef := RecRef.Field(6); // No.
        ReservationEntry.SetRange("Item No.", FldRef.Value);
        ReservationEntry.SetRange("Source Type", RecRef.Number);
        ReservationEntry.SetFilter("Item Tracking", '> %1', ReservationEntry."Item Tracking"::None);
        if ReservationEntry.FindSet() then
            repeat
                TrackingSpecification.Init();
                TrackingSpecification."Entry No." := TrackingSpecification."Entry No." + 1;
                TrackingSpecification."Item No." := ReservationEntry."Item No.";
                TrackingSpecification."Serial No." := ReservationEntry."Serial No.";
                TrackingSpecification."Lot No." := ReservationEntry."Lot No.";
                TrackingSpecification."Quantity (Base)" := Abs(ReservationEntry.Quantity);
                TrackingSpecification.Insert();
            until ReservationEntry.Next() = 0;
    end;

    local procedure GetItemLedgerEntries(var TrackingSpecification: Record "Tracking Specification"; RecRef: RecordRef)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ValueEntry: Record "Value Entry";
        ShippingRef: RecordRef;
        FldRef: FieldRef;
        ShippingFldRef: FieldRef;
    begin
        case RecRef.Number of
            Database::"Sales Line",
            Database::"Sales Invoice Line":
                ShippingRef.GetTable(SalesShipmentLine);
            Database::"Purchase Line",
            Database::"Purch. Inv. Line":
                ShippingRef.GetTable(PurchRcptLine);
        end;

        case RecRef.Number of
            Database::"Sales Line",
            Database::"Purchase Line":
                begin
                    ShippingFldRef := ShippingRef.Field(65);
                    FldRef := RecRef.Field(3); // Document No
                    ShippingFldRef.SetRange(FldRef.Value);
                    ShippingFldRef := ShippingRef.Field(66);
                    FldRef := RecRef.Field(4); // Line No
                    ShippingFldRef.SetRange(FldRef.Value);
                    if not ShippingRef.FindSet() then
                        exit;
                end;
            Database::"Sales Invoice Line",
            Database::"Purch. Inv. Line":
                begin
                    ValueEntry.SetCurrentKey("Document No.");
                    FldRef := RecRef.Field(3); // Document No
                    ValueEntry.SetRange("Document No.", FldRef.Value);
                    FldRef := RecRef.Field(4); // Line No
                    ValueEntry.SetRange("Document Line No.", FldRef.Value);
                    case RecRef.Number of
                        Database::"Sales Invoice Line":
                            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                        Database::"Purch. Inv. Line":
                            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
                    end;
                    if ValueEntry.FindSet() then
                        repeat
                            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                                InsertTrackingSpecFromItemLedgerEntry(TrackingSpecification, ItemLedgerEntry);
                        until ValueEntry.Next() = 0;
                    exit;
                end;
            Database::"Sales Shipment Line",
            Database::"Purch. Rcpt. Line":
                ShippingRef := RecRef;
            else
                exit;
        end;

        ShippingRef.SetRecFilter();
        if ShippingRef.FindSet() then
            repeat
                FldRef := ShippingRef.Field(3); // Document No
                ItemLedgerEntry.SetRange("Document No.", FldRef.Value);
                FldRef := ShippingRef.Field(4); // Line No
                ItemLedgerEntry.SetRange("Document Line No.", FldRef.Value);
                FldRef := ShippingRef.Field(6); // No
                ItemLedgerEntry.SetRange("Item No.", FldRef.Value);
                case RecRef.Number of
                    Database::"Sales Line",
                    Database::"Sales Shipment Line":
                        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                    Database::"Purchase Line",
                    Database::"Purch. Rcpt. Line":
                        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                end;
                ItemLedgerEntry.SetFilter("Item Tracking", '> %1', ItemLedgerEntry."Item Tracking"::None);
                if ItemLedgerEntry.FindSet() then
                    repeat
                        InsertTrackingSpecFromItemLedgerEntry(TrackingSpecification, ItemLedgerEntry);
                    until ItemLedgerEntry.Next() = 0;
            until ShippingRef.Next() = 0;
    end;

    local procedure InsertTrackingSpecFromItemLedgerEntry(var TrackingSpecification: Record "Tracking Specification"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        myInt: Integer;
    begin
        with TrackingSpecification do begin
            Init();
            "Entry No." := TrackingSpecification."Entry No." + 1;
            "Item No." := ItemLedgerEntry."Item No.";
            "Serial No." := ItemLedgerEntry."Serial No.";
            "Lot No." := ItemLedgerEntry."Lot No.";
            "Quantity (Base)" := Abs(ItemLedgerEntry.Quantity);
            Insert();
        end;
    end;
}