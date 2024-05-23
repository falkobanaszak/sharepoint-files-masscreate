<#
.SYNOPSIS
    sharepoint-files-masscreate.ps1 - A small script to mass create random files with random file sizes  within SharePoint Online
.DESCRIPTION
    A small script to mass create random files with random file sizes  within SharePoint Online
.OUTPUTS
    Results are printed to the console.
.NOTES
    Author        Falko Banaszak, https://virtualhome.blog, Twitter: @Falko_Banaszak
    Change Log    V1.00, 22/05/2024 - Initial version: 

.LICENSE
    MIT License
    Copyright (c) 2019 Falko Banaszak
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>
# Import the SharePoint Online Management Shell Module
# You can download it here: https://www.microsoft.com/en-us/download/details.aspx?id=35588
# Or just use "Install-Module SharePointPnPPowerShellOnline -Scope CurrentUser"
Import-Module SharePointPnPPowerShellOnline

# Variables 
$SharePointSiteURL = "https://m365x49111172.sharepoint.com/sites/sharepoint-files-masscreate"
$SharePointLibraryName = "mass-files-library"
$MassFileCount = 100000  # Number of files to create
$MassFilePrefix = "RandomMassFile"  # Prefix for file names
$MinimumFileSizeInKB = 1  # Minimum file size in KB
$MaximumFileSizeInKB = 4096  # Maximum file size in KB

# Connect to the SharePoint Online Site
Connect-PnPOnline -Url $SharePointSiteURL -UseWebLogin

# Function to create mass files in the SharePoint Library with random size
function Create-MassFiles {
    param (
        [string]$RandomFileName,
        [string]$LibraryName,
        [int]$MinSizeKB,
        [int]$MaxSizeKB
    )
    
    # Generate random file size in KB
    $random = New-Object System.Random
    $fileSizeKB = $random.Next($MinSizeKB, $MaxSizeKB + 1)
    
    # Create the random content for the file
    $fileContent = New-Object byte[] ($fileSizeKB * 1024)
    $random.NextBytes($fileContent)
    
    # Upload files to the document library
    $fileStream = New-Object IO.MemoryStream (,$fileContent)
    Add-PnPFile -Folder $LibraryName -FileName $RandomFileName -Stream $fileStream
    Write-Host "Created file: $FileName with size: $fileSizeKB KB"
}

# Create a loop for multiple files
for ($i = 1; $i -le $MassFileCount; $i++) {
    $fileName = "$MassFilePrefix$i.txt"
    Create-MassFiles -FileName $fileName -LibraryName $SharePointLibraryName -MinSizeKB $MinimumFileSizeInKB -MaxSizeKB $MaximumFileSizeInKB
}

# Disconnect from SharePoint Online
Disconnect-PnPOnline