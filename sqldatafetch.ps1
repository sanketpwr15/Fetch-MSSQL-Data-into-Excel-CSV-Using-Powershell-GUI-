### Creating the form with the Windows forms namespace
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Enter the Customer ID' ### Text to be displayed in the title
$form.Size = New-Object System.Drawing.Size(420,420) ### Size of the window
$form.StartPosition = 'CenterScreen'  ### Optional - specifies where the window should start
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow  ### Optional - prevents resize of the window
$form.Topmost = $true  ### Optional - Opens on top of other windows

### Adding an OK button to the text box window
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(160,320) ### Location of where the button will be
$OKButton.Size = New-Object System.Drawing.Size(85,34) ### Size of the button
$OKButton.Text = 'OK' ### Text inside the button
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

### Adding a Cancel button to the text box window
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(70,320) ### Location of where the button will be
$CancelButton.Size = New-Object System.Drawing.Size(85,34) ### Size of the button
$CancelButton.Text = 'Cancel' ### Text inside the button
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

### Putting a label above the text box
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10) ### Location of where the label will be
$label.AutoSize = $True
$Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold) ### Formatting text for the label
$label.Font = $Font
$label.Text = $Input_Type ### Text of label, defined by the parameter that was used when the function is called
$label.ForeColor = 'Red' ### Color of the label text
$form.Controls.Add($label)



### Inserting the text box that will accept input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40) ### Location of the text box
$textBox.Size = New-Object System.Drawing.Size(400,200) ### Size of the text box
$textBox.Multiline = $true ### Allows multiple lines of data
$textbox.AcceptsReturn = $true ### By hitting enter it creates a new line
$textBox.ScrollBars = "Vertical" ### Allows for a vertical scroll bar if the list of text is too big for the window
$form.Controls.Add($textBox)

$form.Add_Shown({$textBox.Select()}) ### Activates the form and sets the focus on it
$result = $form.ShowDialog() ### Displays the form 



### If the OK button is selected do the following
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$x = $textBox.Text #SQL connection to the database
$SQLServer = "DESKTOP-RAS2SGL\SQLEXPRESS"
$SQLDBName = "employee"
$uid =""
$pwd = ""
$SqlQuery = "select * from employee_info where empid in ($x);" #Insert your Query here
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True; User ID = $uid; Password = $pwd;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)


$finalr = $DataSet.Tables[0] 

$finalr | Export-csv -Path .\DATA.csv -Force

}


