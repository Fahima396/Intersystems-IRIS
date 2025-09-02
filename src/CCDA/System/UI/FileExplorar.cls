Class CCDA.System.UI.FileExplorar Extends %ZEN.Component.page
{

Parameter APPLICATION;

Parameter PAGENAME;

Parameter DOMAIN;

Parameter AuditType = "File Explorer";

Parameter AuditSource = "CVS";

XData Style
{
<style type="text/css">
</style>
}
XData Contents [ XMLNamespace="http://intersystems.com/zen" ]
{
<page xmlns="http://m.intersystems.com/zen" title="File Explorer">
<hgroup containerStyle="background:#00AFA9; font-size:10" align="left" width="1000">
<label id="title" value="File Explorer" controlClass="ribbonTitle"/> </hgroup>
<form enctype="multipart/form-data" title="File Upload" autoValidate="true">

<spacer height="20px"/>
<fieldSet containerStyle="border: 1px solid black;" labelPosition="left" label="Create Directory: ">
<hgroup labelPosition="left">
<text id="newDirectory" label="Directory: " size="100" />
<button controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s?showdirectoryonly=1','Create Directory','status,scrollbars,resizable,width=660,height=798');" caption="New Directory:"/>
<button caption="Create" controlClass="commandButton" onclick="zenPage.createDirectory();"/>
</hgroup>
</fieldSet>

<spacer height="20px"/>
<fieldSet containerStyle="border: 1px solid black;" labelPosition="left" label="Upload a file from your machine to the server">
<hgroup>
<spacer width="5px"/>
<label label="File Upload"/> 
</hgroup>
<spacer height="20px"/>
<hgroup labelPosition="left">
<fileUpload id="fileUpload" name="fileUpload" size="100" multiple="true" />
</hgroup>
<hgroup labelPosition="left">
<button id="fileUploadPath" controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s?showdirectoryonly=1', 'FolderSelectWindow', 'status, scrollbars, resizable, width=650, height=700');" caption="Target Folder:" />
<label id="serverFolder" name="serverFolder" />
<submit id="submit" controlClass="commandButton" caption="Submit"/>
</hgroup>
</fieldSet>
<spacer height="20px">
<fieldSet containerStyle="border: 1px solid black;" labelPosition="left" label="Download a file from the server to your local machine">
<hgroup>
<spacer width="5px"/>
<label label="File Download"/>
</hgroup>
<spacer height="10px">

<hgroup labelPosition="left">
<button id ="fileDownloadPath" controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s', 'FileSelect', 'resizable.width=600,height=700');" caption="Select File:" />
<text id="fileDownloadFull" name="fileDownloadFull" size="100" readOnly="true" />
<button caption="Download" controlClass="commandButton" onclick="zenPage.DownloadStream();" />
</hgroup>
</fieldSet>

<spacer height="20px"/>
<fieldSet label="Move/Copy a file" containerStyle="border: 1px solid black;">
<hgroup labelPosition="left">
<text id="moveCopyFile" name="Source File: " size="100" />
<button id ="moveCopyFileSource" controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s?showdirectoryonly=0', 'Move/Copy File', 'status,scrollbars,resizable.width=600,height=700');" caption="Select File:" />
</hgroup>
<hgroup labelPosition="left">
<text id="moveCopyDestination" name="Destination: " size="100" />
<button id ="moveCopyFileDestination" controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s?showdirectoryonly=0', 'Move/Copy Target File', 'status,scrollbars,resizable.width=600,height=700');" caption="Select File:" />
</hgroup>
<hgroup>
<button caption="Move" controlClass="commandButton" onclick="zenPage.moveFile();" />
<button caption="Copy" controlClass="commandButton" onclick="zenPage.copyFile();" />
</hgroup>
</fieldSet>

<spacer height="20px"/>
<fieldSet containerStyle="border:  1px solid black;" labelPosition="left" label="Delete File">
<hgroup labelPosition="left" >
<text id="deleteFile" label="Delete File:" size="100"/>
<button id ="fileDeletePath" controlClass="commandButton" onclick="zenPage.launchPopupWindow('ZEN.Dialog.fileSelect.c1s?showdirectoryonly=0', 'Delete File', 'status,scrollbars,resizable.width=600,height=700');" caption="Select File:" />
<button caption="Delete File" controlClass="commandButton" onclick="zenPage.deleteFile();" />
</hgroup>
</fieldSet>

</form>

</page>






}








}
