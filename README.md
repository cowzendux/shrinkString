# shrinkString
This is an SPSS Python macro that can set every string variable to the smallest size that will fit all values.

## Usage
**shrinkString(varList)**
* "varList" is a list of strings representing the variables that should be reduced. If a string does not correspond to a variable in the dataset it will be ignored. If a string corresponds to a non-string variable it will be ignored. If this argument is not provided, then the function will attempt to shrink all string variables in the data set.

## Example
**shrinkString(["FirstName", "LastName", "Profession"])**
* This command would first review all of the values in the FirstName variable and find the length of the longest value. It would then alter the type of the FirstName variable so that it was just long enough so that the longest value could be accommodated.
* It would repeat this process for the LastName and Profession variables.

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html
