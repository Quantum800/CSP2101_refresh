#!/bin/bash
#===========================================+
# Name:             Matthew HARRINGTON      #
# Student number:   2001901                 #
# Assignment:       Portfolio Assignment 2  #
#===========================================+

#========================================================================== MAIN BODY ==========================================================================
#===============================================================================================================================================================

# This command backups the original rectangle.txt to the backup.bak which will then be used to restore the original rectangle.txt file
cp rectangle.txt rectangle.bak


# This sed command deletes the column titles from rectangle.txt.  The -i argument enables sed to make permanent changes to the target file, in this case rectangles.txt.
# The '1d' tells sed to delete the first line in the file.

sed -i '1d' rectangle.txt


# SED COMMAND OVERVIEW
# ====================
# use of '|'' as a substitute delimiter for the '/' delimiter in sed commands is adapated from https://stackoverflow.com/questions/40714970/escaping-forward-slashes-in-sed-command.
# The benefits are that  it easier to read and understand the commands when escape characters form part of the sed command.

# The use of the '&' was adapted from https://stackoverflow.com/questions/13170623/regex-for-appending-text-using-sed as a holder value for the pattern match from the sed substitute command
# It allows the matched pattern to be manipulated.

# As well as the -i argument, all of the following command use the -E argument to enable the use of Extended Regular Expressions (http://gnu.org/software/sed/manual/sed#Regular-Expressions-Overview) 


# FORMAT THE NAME VALUES:
# ========================
# This sed command work by matching the beginning of each line that starts with 'Rec' and at least one digit i.e. Rec1, Rec2.. Rec20 and then prepending that
# match (as represented by the & symbol) with 'Name: ' and saving the changes to the orginal rectangle.txt file.
sed -i -E "s|^(Rec)[0-9]+|Name: &|" rectangle.txt 


# FORMAT THE HEIGHT VALUES:
# ========================
# This sed command work by matching substituting the first instance of the of a ',' and replacing it with 'Height:' before saving the changes.

sed -i -E "s|\,|\tHeight:\t|" rectangle.txt

# FORMAT THE WIDTH VALUES:
# ========================
# This sed command work by matching substituting the first instance of the of a ',' in the new version of rectangle.txt created by the previous sed commandand replacing it with 'Width:'

sed -i -E "s|\,|\tWidth:\t|" rectangle.txt

# FORMAT THE AREA VALUES:
# ========================
# This sed command work by matching substituting the first instance of the of a ',' in the new version of rectangle.txt created by the previous sed commandand replacing it with 'Area:'

sed -i -E "s|\,|\tArea:\t|" rectangle.txt

# FORMAT THE COLOUR VALUES:
# ========================
# This sed command work by matching substituting the first instance of the of a ',' in the new version of rectangle.txt created by the previous sed commandand replacing it with 'Colour:'

sed -i -E "s|\,|\tColour: |" rectangle.txt

# This command copies the modified rectangle.txt value to the output file rectangle_f.txt
cp rectangle.txt rectangle_f.txt

# This commands restore the rectangle.txt file to its original state from rectangle.bak and removes all the temporary files created by the script.
cp rectangle.bak rectangle.txt
rm rectangle.bak