# Copyright 2024 Rayyan Hodges, TAFE NSW, AlphaDelta﻿
# Contact: rayyan.hodges@studytafensw.edu.au
# Program Name: AutoOUADCreator
# Purpose of script: Create a batch set of OU' using a CSV file within an existing Active Directory Forest.
# Extra Notes: Modify line 37 and 59 with appropriate domain info. (AlphaDelta.com is used in this scenario)

#Import the Active Directory module to allow modifcations to the forest.
import-module ActiveDirectory

#Get user to specify path of the CSV file containing OU names to be added into the Active Directory.
$fpath = Read-Host -Prompt "Please enter the path to your CSV file containing OU info to be added within the Active Directory Domain Forest"

# Check if the CSV file exists
if (Test-Path $fpath) {
    # Display path to file given by end-user
    Write-Host "CSV file path: $fpath"

# Display path to file given by end-user
echo $fpath

 # Import OU info from CSV file with error checking
    try {
        $fous = Import-Csv $fpath -ErrorAction Stop
    } catch {
        Write-Host "Error importing CSV file: $_"
        exit
    }

#Create OU's within the Active Directory forest by looping throughout each row within the CSV file.
foreach ($row in $fous) {
        # Get the name of the OU from the CSV
        $ouName = $row.ouName

        # Debug output - Check if program is actually reading CSV containing OU names.
        Write-Host "Processing OU name: '$ouName'"

        # Ensure $ouName is not null or empty
        if (-not [string]::IsNullOrWhiteSpace($ouName)) {
# Get all existing OUs in the specified path
            try {
                $existingOUs = Get-ADOrganizationalUnit -Filter * -SearchBase "DC=alphadelta,DC=com" | Select-Object -ExpandProperty Name
            } catch {
                Write-Host "Error retrieving existing OUs: $_"
                exit
            }

# Check if the OU already exists
$ouExists = $false
foreach ($existingOU in $existingOUs) {
    if ($existingOU -eq $ouName) {
        $ouExists = $true
        break
    }
}

if (-not $ouExists) {
                # Create the OU
                try {
                    New-ADOrganizationalUnit -Name $ouName -Path "DC=alphadelta,DC=com" -ErrorAction Stop
                    Write-Host "OU '$ouName' created successfully."
                } catch {
                    Write-Host "Error creating OU '$ouName': $_"
                }
            } else {
                Write-Host "OU '$ouName' already exists, proceeding to next entry."
            }
        } else {
            Write-Host "Skipping empty OU name."
        }
    }
} else {
    Write-Host "The specified CSV file does not exist."
}
