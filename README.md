CSV-Import.ps1
========

This script creates new users in Active Directory by iterating through a CSV file with user information that will be filled in for that user. ExampleUsers.csv provides a basic framework for creating a CSV file to use.

Using the script
---
This script requires that the $ADUsers variable points to the full path of the CSV file on your machine. The variables listed in the foreach loop are based off the column headers in your CSV file. Please be sure before running the script that your variables and column headers match to prevent errors.

Modifying the script
---

This script is by no means all inclusive for creating new Active Directory users. Type `help New-ADUser` in your Powershell session or go [here](http://go.microsoft.com/fwlink/p/?linkid=291077) to get a full list of parameters and examples.
