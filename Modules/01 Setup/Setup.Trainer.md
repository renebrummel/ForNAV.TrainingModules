# Setup
<dl>
  <dt><b>Level</b></dt>
  <dd>Basic</dd>
  <dt><b>Duration</b></dt>
  <dd>10 min</dd>
  <dt><b>Instructor participation</b></dt>
  <dd>Lead reflection</dd>
  <dt><b>Training approach</b></dt>
  <dd>Self Study</dd>
  <dt><b>Prerequisites</b></dt>
  <dd>All students have access to a Business Central instance (On Premise or SaaS) with the Cronus Database with a valid license. <br> All students have the ForNAV designer installed in the same environment.</dd>
  <dt><b>Training materials</b></dt>
  <dd>ForNAV.Guide Setup</dd>
  <dt><b>Objective</b></dt>
  <dd>After this module students have set up their ForNAV designer</dd>
</dl>

## Preparation
Duration: -

Download and install the ForNAV designer from the ForNAV website.
This is a pretraining exercise. Email instructions to participants before training.

<!-- Add video -->
### Video script
Hi and welcome to this ForNAV training. We will start the training with the installation and setup of Reports ForNAV. The installation and Setup of ForNAV comes in two types, Cloud and On Premise. Please use the setup that is suitable for your installation type.

**Cloud**

The installation of ForNAV cloud starts with the installation of the Customizable Report Pack in your Business Central Tenant. This will install everything you need to run, edit, and create ForNAV reports.

DEMO

*Using a new sandbox Install the Customizable Report Pack from the Marketplace. Show which extensions are installed.*

Once we have installed the Customizable report pack we can download and install the ForNAV Designer

DEMO

*Install the ForNAV Designer.*

When we have installed the ForNAV Designer we need to set it up correctly. We need to connect the ForNAV Designer to the Business Central tenant so it can read table and field information, load and save reports, and manage extensions.

DEMO

*Set up the ForNAV Designer to connect to Business Central Cloud.*

Once we have done this we are ready to work with ForNAV.

**On Premise**

The installation of ForNAV cloud starts with the installation of the ForNAV Designer. This will install everything you need to run, edit, and create ForNAV reports. You need to install the ForNAV Designer on the system where you plan to design reports. On every service tier you plan to use you need to install the ForNAV Service add in.

DEMO

*Install the ForNAV Designer.*


When we have installed the ForNAV Designer we need to set it up correctly. We need to connect the ForNAV Designer to the Business Central service tier so it can read table and field information, load and save reports, and manage extensions.

DEMO

*Set up the ForNAV Designer to connect to Business Central On Prem. Show which extensions are installed on the server.*

Once we have set up the ForNAV Designer correctly we can install the ForNAV Customizable Report Pack. This is not mandatory but it is highly recommended.

DEMO

*Download and install the Customizable Report Pack extension and upload it to the server using the Designer. Show which extensions are installed.*

Once we have done this we are ready to work with ForNAV.


**Setup of the ForNAV Customizable Report Pack**

After installing the ForNAV Customizable Report Pack you can set it up so the ForNAV reports get added to your report selection, and add your logo, payment terms, etc.

DEMO

*Wizard, ForNAV Setup, ForNAV Reports, My Reports.*
<!-- /Add Video -->

> https://www.fornav.com/download/

## Execution
Duration: -

[filename](../../Exercises/Setup.Exercise.md ':include')

## Reflection
Duration: 10 min

In the first meeting ask everyone if they managed to setup ForNAV correctly. Determine what went right and what did not.

### Questions
Why do you need to set up the connection in the ForNAV Designer?
* To get the table and field information from Business Central and to be able to load and save extensions and layouts directly to Business Central
* To spy on your clients
* To load data directly from Business Central into the report layouts

Which ports need to be open in your On Premise server?
* SOAP, ODATA, API, and Developer
* Nothing
* Developer, Client Services, SOAP

What is the correct installation order for ForNAV On Premise?
* ForNAV Designer, ForNAV dll on the service tier, ForNAV Customizable Report Pack
* No specific order of installation
* ForNAV Customizable Report Pack, ForNAV Designer, ForNAV dll on the service tier

What is the correct installation order for ForNAV SaaS?
* No specific order of installation
* ForNAV Designer, ForNAV dll on the service tier, ForNAV Customizable Report Pack
* ForNAV Customizable Report Pack, ForNAV Designer, ForNAV dll on the service tier
<!-- Add questions -->
