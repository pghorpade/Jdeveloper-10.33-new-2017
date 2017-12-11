// Callback function for "Test Connection" button in URL Wizard.
// Author: echolank
// Date: 10/11/05

function selectCallBack(Win, field, event)
{
  // called when the window is closed
  // look in window for the value of the SQL statement,
  // and submit that!
  var sqlStatementField = Win.document.getElementById('sqlStatement');
  // refreshes page so that success/error message is displayed
  submitForm('iasform',0,{'event':'testConn','sqlStatement':sqlStatementField.value});
  return true;
}
