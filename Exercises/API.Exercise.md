### ForNAV API Exercise

Using the new Sales Invoice report extension you created earlier do:
* Add a new global Text variable in your report, call it MyText
* Add a column in the Header DataItem on the MyText variable
* Add a request page option in the AL file based on the MyText variable
* Open the report in the ForNAV Designer and add a new text box on the Report Header and add DynamicsNavDataSet.MyText as the source expression
* In the ForNAV setup import the Document Watermark. Either download one from ForNAV or import your own
* Add the LoadWatermark function and the call to it in the OnPreReport function
* appendpdf/prependpdf

Advanced exercise
* Language

Use the ForNAV Guide for [SaaS]() or [OnPrem]()

<!-- ToDO -> edit links -->

**Load Watermark function**
```AL
	trigger OnPreReport()
	begin
		;ReportsForNavPre;
		LoadWatermark();
	end;

	local procedure LoadWatermark()
	var
		ForNAVSetup: Record "ForNAV Setup";
		OutStream: OutStream;
	begin
		with ForNAVSetup do begin
			Get;
			CalcFields("Document Watermark");
			if not "Document Watermark".Hasvalue then
				exit;

			ForNavSetup."Document Watermark".CreateOutstream(OutStream);
			ReportForNav.Watermark.Image.Load(OutStream);
		end;
	end;
```


Use the list watermark in the ForNAV Setup and append that to your report
3.	Create a pdf file and save that as “C:\Temp\Append.pdf”;
4.	Add this code to the OnInitReport() section of your report:

```AL
MyFile.OPEN('C:\Temp\Append.pdf');
MyFile.CREATEINSTREAM(MyInStream);
ReportForNav.GetDataItem('Header').AppendPdf(MyInStream);
```
