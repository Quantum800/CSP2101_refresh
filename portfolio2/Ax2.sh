#!/bin/bash
#===========================================+
# Name:             Matthew HARRINGTON      #
# Student number:   2001901                 #
# Assignment:       Portfolio Assignment 2  #
#===========================================+

# VARIABLE DEFINTIONS:
# --------------------
# number_lines:     A count of the the number of lines in the input text file (rectangle.txt).
# counter:          Counter used in UNTIL loop that counts number of lines in the file.
# directory_path:   The directory path where the rectangle.txt file is located, manually entered by user.
# file_location:    Full pathname for where rectangle.txt is located.
# backup_location:  Full path where of the backup file of rectangle.txt.
# temp_path:        The directory path where the dirpath.txt file will be located - dirpath is a temp file used in the sed command to store output.
# valid_directory:  Counter used as an exit condition for the directory and file validation loop.
# temp_value:       Variable storing all the data from rectangles.txt.
# temp_rec:         Name of the file where the temporary rectangle data from rectangles.txt is outputed.
# name:             Variable used to store 'name' value that is read in from rectangle.txt.
# height:           Variable used to store 'height' value that is read in from rectangle.txt.
# width:            Variable used to store 'width' value that is read in from rectangle.txt.
# area:             Variable used to store 'area' value that is read in from rectangle.txt.
# colour:           Variable used to store 'colour' value that is read in from rectangle.txt.
# dp:               Temporary storage variable used in the loop to store file location location before being written to file.

#================================================================ SELECT INPUT FILE FUNCTION ===================================================================
#===============================================================================================================================================================
# Check if file exist prior to running script - script inspired from week6 workshop.
# If script detects that user input is a valid directory then the scripts breaks from the WHILE loop and continues with the script otherwise it will echo to the
# user that the input was not a valid directory and loop again to the input prompt and repeat until a valid directort is provided.

Select_Input_File()
{
valid_directory=0

while (( valid_directory != 1 )); do
read -p "please enter the directory where the rectangle.txt file is located: " directory_path
if [[ -d "$directory_path" ]]; then
echo $directory_path > dirpath.txt

#-------------------------------------------------------------------- Establish directory paths ----------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Appends file name to the end of the directory path.

file_location="${directory_path}/rectangle.txt" 
backup_location="${directory_path}/rectangle.bak"
temp_path=$(pwd)
temp_path="${temp_path}/dirpath.txt"

#-------------------------------------------------------------------- Backup rectangle.txt ---------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------validate directory path of file ----------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# use of '| in sed command inspired from https://stackoverflow.com/questions/40714970/escaping-forward-slashes-in-sed-command. Sed command replaces all
# instances of multiple forward slashes with a single forward slash. Use of | instead of forward slashes used as an alternative delimiter to eliminate issues
# with regex expression that require the use of escape characters i.e '\n', '\t' etc. It then appends rectangle.txt to the end of the path to create the full 
# pathname for the file.

sed -i -E "s|/*$|/rectangle.txt|g" dirpath.txt
((valid_directory++))
break

#------------------------------------------------------------------- else section of while loop ----------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
else
echo -e "$directory_path is not a directory\nPlease enter directory details again"
fi
done

#------------------------------------------------------------------- WHILE LOOP - read file --------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# the code from below was adapated from code from the following website https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# It reads in the data stored in dirpath.txt and stores it to the directory_path variable for use in the scripts. $dp is a temporary vairable used to store the
# value before writing it to dirpath.txt.
while read dp; do
directory_path="$dp"
done < dirpath.txt
}

#================================================================= SED PROCESSING FUNCTION =====================================================================
#===============================================================================================================================================================
# Function that uses sed to manipulate the data from rectangles.txt into a user friendly format:
#
# $1: the variable that is parsed in from the rectangle.txt file
# $2: label to identify the variable in the line
# $3: end of line value all should be "" with the exception of colour which ends with a newline (essentially a record separator for AWK processing)
#
# The sed function searches for a line that starts with (^ regex character) the value and replaces it with a formatted string starting with
# $2 (the variable label), then a semicolon, a space and ends with either "" or a '\n' character. 

sed_processing()
{
    echo $1 >> $temp_rec
    sed -iE "s|^$1|$2: $1$3|1" $temp_rec
}

#========================================================================== MAIN BODY ==========================================================================
#===============================================================================================================================================================
# Define the temporary text file which is used as an intermediate file to temporarily write modified data to file to be processed later on.
temp_rec="rectangle_temp.txt"

# Function call
Select_Input_File

# Backup the original rectangle.txt (as the file will be modified by Sed) which will then be restored at the end of the script.
cp "$file_location" "$backup_location"

# This sed command deletes the first line of the rectangle.txt file as it contains the column titles ("Name,Height,Width,Area,Colour") leaving only the data for processing.
sed -i '1d' "$directory_path"

# Counts the number of lines in the file,  adapted from https://stackoverflow.com/questions/3137094/how-to-count-lines-in-a-document.
number_lines=$(wc -l < "$directory_path")
counter=0

# The UNTIL loop reads each line of the rectangle.txt file until it reaches the last line ($number_lines). As all the values in the modified rectangle.txt file
# are separated by ',' the IFS value is set as ',' and will read all the values and store them in a temporary file rectangle_temp.txt for processing. 
until (( $counter > $number_lines )); do
IFS="," read name height width area colour

#Call sed functions
sed_processing $name "Name" ""
sed_processing $height "Height" ""
sed_processing $width "Width" ""
sed_processing $area "Area" ""
sed_processing $colour "Colour" "\n"

((counter++))
done < $directory_path
#--------------------------------------------------------- output formatted file to rectangle_f.txt ------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# AWK code adapted from https://www.gnu.org/software/gawk/manual/html_node/Printf-Examples.html
# In the BEGIN section of the ask command a title bar is created which is added to the top of the file, in the END section a double line is added for presentation.
# The main body uses the printf function to insert '|' as column dividers and specify the spacing for each value.

awk 'BEGIN {RS=""; printf "%-30s", "====================================================================\n";
printf "\t\t\t\tRECTANGLES\n";
printf "%-30s", "====================================================================\n"} 
 {printf "%s %5s | %s %2d | %s %d | %s %5d | %s %s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}
END {print "====================================================================";
print "===================================================================="}' ./rectangle_temp.txt >> rectangle_f.txt

#---------------------------------------------------------------------------- clean up -------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# This section removes all the temporary file used by the script (including rectangle.bak) and restores the original rectangle.txt.
cp "$backup_location" "$file_location"
rm dirpath.txt rectangle_temp.txt rectangle_temp.txtE
rm "$backup_location"