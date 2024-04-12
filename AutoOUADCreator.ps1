# Copyright 2024 Rayyan Hodges, TAFE NSW, AlphaDelta
# Contact: rayyan.hodges@studytafensw.edu.au
# Program Name: AutoOUADCreator
# Purpose of script: Create a batch set of OU' using a CSV file within an existing Active Directory Forest.
# Extra Notes: Modify line 37 with appropriate domain info. (AlphaDelta.com is used in this scenario)

#Import the Active Directory module to allow modifcations to the forest.
import-module ActiveDirectory



#Get user to specify path of the CSV file containing OU names to be added into the Active Directory.
$fpath = Read-Host -Prompt "Please enter the path to your CSV file containing OU info to be added within the Active Directory Domain Forest:"


# Check if CSV file exists with the path specified by the end-user
# If so, error out the program with generic error stating so. (RAYYAN Contribution)
# This uses the "Test-Path" cmdlet which tests if the path actually exists and can be read by the system.
# Source for code (https://www.itechguides.com/powershell-check-if-file-exists/#:~:text=If%20(Test%2DPath%20%2DPath%20E%3A%5Creports%5Cprocesses.txt%20)%20%7B%0ACopy%2DItem%20%2DPath%20E%3A%5Creports%5Cprocesses.txt%20%2DDestination%20C%3A%5Creports%0A%7D)

}

# Display path to file given by end-user
echo $fpath

#Import OU info from CSV file.
$fous = Import-Csv $fpath

#Create OU's within the Active Directory forest by looping throughout each row within the CSV file.
foreach ($row in $ouData) {
        # Get the name of the OU from the CSV
        $ouName = $row.Name

        # Check if the OU already exists
        if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $ouName})) {
            # Create the OU
            New-ADOrganizationalUnit -Name $ouName -Path "DC=alphadelta,DC=com" -ErrorAction SilentlyContinue
            Write-Host "OU '$ouName' created successfully."
            # If OU name already exists, simply display a message stating it exists and skip to next entry.
        } else {
            Write-Host "OU '$ouName' already exists, proceeding to next entry."
        }
    }
    # Basic check 
} else {
    Write-Host "CSV file not found at $csvPath"
}