# Designer deep dive
<dl>
  <dt><b>Level</b></dt>
  <dd>Basic</dd>
  <dt><b>Duration</b></dt>
  <dd>75 min</dd>
  <dt><b>Instructor participation</b></dt>
  <dd>Web: Demonstrate the designer features<br>Classroom: Demonstrate the designer features</dd>
  <dt><b>Training approach</b></dt>
  <dd>Demo, exercise, reflect on exercise</dd>
  <dt><b>Prerequisites</b></dt>
  <dd>All students have access to a Business Central instance (OnPrem or SaaS) with the Cronus Database with a valid license. <br> All students have the ForNAV designer installed in the same environment.</dd>
  <dt><b>Training materials</b></dt>
  <dd>ForNAV Guide</dd>
  <dt><b>Objective</b></dt>
  <dd>After this module students will be able to add all types of controls and control the properties of those controls.</dd>
</dl>

# Pre Training
Watch the video [ForNAV Basic Features](ToDo)

# Preparation
Duration: 30 min

Demo:
ForNAV Controls (Tool Box)
* Label
* Text Box
* Picture Box
* Image
* Cross Section Line + Box
* Shape
* Bar Code
* Table

Lint
* Explain options in Open/New/Save/Extensions
* Mention Undo/Redo
* Fonts
* Alignment + layout -> Mostly self explanatory

Design Pane
* DataItems
* Sections
* Controls

Report Explorer
* Mention that this is where all the items in the report end up
* DataItems
* Sections
* Controls

Property Grid
* Can Grow
* Mutliline
* Format String
* Auto Fit
* Styles

Field List
* CurrReport
* DynamicsNavDataSet
* DataItems
  * Fields
  * FieldCaptions
  * FieldLookups
  * FieldOptions
* Add tables from Field List
* Add Picture/Bar Code from Field List

# Execution
Duration: 30 min

Add to the Sales Template:
* Change the font, color and background color for the fields in the LinesHeader 
* A label, with translation if needed
* Add the Picture field from the Company Information as a picture control
* Add the Header.BillToCustomerNo as a Bar Code of type QRCode
* Add a Line Body section and in that body section add these fields as a table
  * Description
  * Description2
* Make the Header.FieldGroups.Bill_toAddress control small and set the Can Grow property to true
* Add an even style on the LinesTable in the LinesBody

Use the ForNAV Guide for [Saas](ToDo) or [OnPrem](ToDO)

# Reflection
Duration: 15 min

Go over each exercise and discuss what happened at every point.

