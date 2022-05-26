
# Import active directory module 
Import-Module ActiveDirectory
  
# Create variable with the route 

$ADUsers = Import-Csv C:\infouser.csv -Delimiter ";"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $user = User.username
    $password = $User.password
    $nombre = $User.firstname
    $apellido = $User.lastname
    $OU = $User.ou 
    $departmento = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $user `
            -GivenName $nombre `
            -Surname $apellido `
            -Enabled $True `
            -Path $OU `
            -Department $departamento `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True
    }
}

Read-Host -Prompt "Press Enter to exit"
