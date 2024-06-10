* Encoding: UTF-8.
* shrinkString
* by Jamie DeCoster

* Python function to set every string variable to the smallest size that will fit all values.

**** Usage: shrinkString(varList)
**** "varList" is a list of strings representing the variables that should be reduced. If a string does not
* correspond to a variable in the dataset it will be ignored. If a string corresponds to a non-string 
* variable it will be ignored. If this argument is not provided, then the function will attempt to shrink
* all string variables in the data set.

BEGIN PROGRAM PYTHON3.
import spss

def descriptive(variable, stat):
# Valid values for stat are MEAN STDDEV MINIMUM MAXIMUM
# SEMEAN VARIANCE SKEWNESS SESKEW RANGE
# MODE KURTOSIS SEKURT MEDIAN SUM VALID MISSING
# VALID returns the number of cases with valid values, and MISSING returns
# the number of cases with missing values

     if (stat.upper() == "VALID"):
          cmd = "FREQUENCIES VARIABLES="+variable+"\n\
  /FORMAT=NOTABLE\n\
  /ORDER=ANALYSIS."
          freqError = 0
          handle,failcode=spssaux.CreateXMLOutput(
          	cmd,
          	omsid="Frequencies",
          	subtype="Statistics",
          	visible=False)
          result=spssaux.GetValuesFromXMLWorkspace(
          	handle,
          	tableSubtype="Statistics",
          	cellAttrib="text")
          if (len(result) > 0):
               return int(result[0])
          else:
               return(0)

     elif (stat.upper() == "MISSING"):
          cmd = "FREQUENCIES VARIABLES="+variable+"\n\
  /FORMAT=NOTABLE\n\
  /ORDER=ANALYSIS."
          handle,failcode=spssaux.CreateXMLOutput(
		cmd,
		omsid="Frequencies",
		subtype="Statistics",
		visible=False)
          result=spssaux.GetValuesFromXMLWorkspace(
		handle,
		tableSubtype="Statistics",
		cellAttrib="text")
          return int(result[1])
     else:
          cmd = "FREQUENCIES VARIABLES="+variable+"\n\
  /FORMAT=NOTABLE\n\
  /STATISTICS="+stat+"\n\
  /ORDER=ANALYSIS."
          handle,failcode=spssaux.CreateXMLOutput(
		cmd,
		omsid="Frequencies",
		subtype="Statistics",
     		visible=False)
          result=spssaux.GetValuesFromXMLWorkspace(
		handle,
		tableSubtype="Statistics",
		cellAttrib="text")
          if (float(result[0]) != 0 and len(result) > 2):
               return float((result[2]))

def shrinkString(varList = None):
# Create a list of all string vars in dataset
    stringList = []
    for varnum in range(spss.GetVariableCount()):
        if (spss.GetVariableType(varnum) > 0):
            varname = spss.GetVariableName(varnum)
            stringList.append(varname.upper())

# Determine variables to be processed
    if (varList == None):
# Processing all string variables if argument omitted    
        processList = stringList
    else:
# Only processing string variables in data set
        processList = []
        for var in varList:
            if (var.upper() in stringList):
                processList.append(var.upper())

# Determine maximum length for each variable in processList
    lengthList = []
    for var in processList:
        submitstring = """compute L6294574 = char.length({0}).
execute.""".format(var)
        spss.Submit(submitstring)
        lengthList.append(int(descriptive("L6294574", "MAXIMUM")))
    spss.Submit("delete variables L6294574")
    
# Change string lengths to maximum value
    for var, length in zip(processList, lengthList):
        submitstring = "alter type {0} (A{1}).".format(var, length)
        spss.Submit(submitstring)
end program python.

******
* Version History
******
* 2021-04-12 
