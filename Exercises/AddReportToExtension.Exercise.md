### Add reports to an extension Exercise

* Create a new empty extension
* Add the dependencies to the ForNAV Core and ForNAV Report Pack
* Create a new Sales Invoice report based on the Header Line template in the ForNAV Designer and save it as an AL object in your extension
* Publish your extension
* Change something in your report, save it and publish your extension form VS Code

Advanced exercise
* Download the Customer List report extension you created earlier and add that report to your new extension

Use the ForNAV Guide for [SaaS]() or [OnPrem]()

[Demo extension with examples](https://github.com/renebrummel/ForNAV.TrainingModules/tree/master/Modules/20%20Add%20Reports%20To%20An%20Extension/AddReportsToExtensionDemo)
<!-- ToDO -> edit links -->

### The ForNAV dependencies

```json
  "dependencies": [
    {
      "id": "63ca2fa4-4f03-4f2b-a480-172fef340d3f",
      "publisher": "Microsoft",
      "name": "System Application",
      "version": "16.0.0.0"
    },
    {
      "id": "437dbf0e-84ff-417a-965d-ed2bb9650972",
      "publisher": "Microsoft",
      "name": "Base Application",
      "version": "16.0.0.0"
    },
    {
      "id": "6f0293d3-86fc-4ff8-9632-54a580be6546",
      "name": "ForNAV Core",
      "publisher": "ForNAV",
      "version": "5.0.0.0"
    },
    {
      "id": "83326d6d-11f8-49fd-981a-6f266a7c8d81",
      "name": "Customizable Report Pack",
      "publisher": "ForNAV",
      "version": "5.0.0.0"
    }
  ],
```