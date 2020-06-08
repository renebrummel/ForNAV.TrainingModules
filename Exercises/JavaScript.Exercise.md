### JavaScript Exercise

* Get the sales comment lines for an invoice header and display them on an automatically growing header section

Advanced option
* Get an array of Sales Invoice Line comments
* Sort the array by date, the most recent comment first
* Display them underneath the VAT Amount Line

Use the ForNAV Guide for [SaaS]() or [On Premise]()

<!-- ToDO -> edit links -->

### Demo Scripts

**Get comment lines**

For maximum effect this should be placed in the OnPreReport trigger so it can be inherited by any reports that use it as a master template

```javascript
function GetComments(headerNo) {
  var comments;
  
  SalesCommentLine.SetFilter('DocumentType', SalesCommentLine.FieldOptions.DocumentType.PostedInvoice);
  SalesCommentLine.SetFilter('No', headerNo);
  if (SalesCommentLine.First()) {
    comments = SalesCommentLine.Comment;
  }
  
  while (SalesCommentLine.Next()) {
    comments += ' ' + SalesCommentLine.Comment;
  }
  return comments;
}
```

**Get comment lines as an array**

Add this to the Header OnAfterGetRecord
```javascript
var comments = [];
function GetComments(headerNo, lineNo) {
  var _comments = [];
  var _comment;
  
  SalesCommentLine.SetFilter('DocumentType', SalesCommentLine.FieldOptions.DocumentType.PostedInvoice);
  SalesCommentLine.SetFilter('No', headerNo);
  SalesCommentLine.SetFilter('LineNo', lineNo);

  if (SalesCommentLine.First()) {
    _comment = {date:SalesCommentLine.Date, lineNo:Line.LineNo, comment:SalesCommentLine.Comment};
    _comments.push(_comment);
  }
  
  while (SalesCommentLine.Next()) {
    _comment = {date:SalesCommentLine.Date, lineNo:Line.LineNo, comment:SalesCommentLine.Comment};
    _comments.push(_comment);
  }
  return _comments;
}
```

Add this to the Line.OnAfterGetRecord
```javascript
comments.push.apply(comments, GetComments(Line.DocumentNo, Line.LineNo));
```



### Business Central functions in JavaScript

|JavaScript                     |AL                             |
|-------------------------------|-------------------------------|
|Get();)                        |Get();                         |
|CalcFields(‘Picture’);         |CalcFields(Picture);           |
|SetAutoCalcFields(‘Balance’);  |SetAutoCalcFields(Balance);    |
|Init();                        |Init;                          |
|Next();                        |Next;                          |
|First();                       |FindFirst;                     |
|SetFilter(‘Name’, ‘Mark’);     |SetFilter(Name, ‘Mark’);       |
|SetRange(‘Name’, ‘Mark’);      |SetRange(Name, ‘Mark’);        |
|<br>
|Case Sensitive                 |Not case sensitive             |
|Parentheses mandatory          |Parentheses somewhat mandatory |
|Fieldnames in single quotes	|Fieldnames not in quotes   	|
|Brackets {}                    |Begin...End;                   |

### JavaScript Order of execution
![JavaScript Order of execution](../_Media/ForNAV%20Order%20of%20execution.png)

### Useful links

Online Learning
* [Codecademy](https://www.codecademy.com/)
* [Knowledge Base Dynamic control of fonts](https://www.fornav.com/knowledge-base/dynamic-control-of-color-and-font-in-text-boxes/ )
* [Online JavaScript Editor](https://js.do/)
* [W3Schools JavaScript](https://www.w3schools.com/js/default.asp)

Videos
* [Learn JavaScript in one video](https://www.youtube.com/watch?v=fju9ii8YsGs)
* [Change fonts/color/show output with JavaScript](https://www.youtube.com/watch?v=T-GY6ObU82c&list=PLtpjnuA-F0c_XQ-y7kGZKAWCXeop7F7Wa&index=11)
* [Working with JavaScript in the ForNAV Designer](https://www.youtube.com/watch?v=4cwbxUq-tc8&t=0s&index=11&list=PLtpjnuA-F0c9bZf3emvhz86-S1uX0a0II)

