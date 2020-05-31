#!/bin/bash
#Joseph Parker
#10496326

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt
cat temp.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" > imagelist.txt
#Captures all the JPG links and puts it into a file


while true; do
#Begins the main loop of the program

    read -p 'Enter 1 for specific image, 2 for all images, 3 for a range of images, 4 for random images, and 5 to exit: ' selection
    #Recieve input from user to select which function of the program they would like to run

    if [ $selection = 1 ]; then
    #if the user enters 1; run this function

        while true; do

            read -p "Enter a specific image number: " imagenum
            #Recieve input from user regarding the image they would like to download and store it as a variable named imagenum

            if grep -q "$imagenum" imagelist.txt && [ "${#imagenum}" = 4 ]; then
            #Check if the value can be found in the imagelist.txt file AND the user entered four characters

                imagetodl=$(grep "$imagenum" imagelist.txt)
                #store retrieved url from image number

                curl -i -s "$imagetodl" > imagelength.txt
                #Use curl to grab the header of the image and write it to a file called imagelength.txt
                lengthline=$(grep -a "Length: ....." imagelength.txt)
                #Select only the byte size of the file of the image being selected and store it as a variable named lengthline
                echo "$lengthline" > imagelength.txt
                #Overwrite imagelength.txt with the bytesize of the image
                fsize=$(sed -e 's/Content-Length: //; s/\r//' imagelength.txt)
                #Select only the bytesize of the image, stripping the Content-Length and the proceeding \r
                kbsize=$(echo "scale=2 ; $fsize / 1024" | bc)
                #Calculate the size in KB from bytes (1KB = 1024 Bytes), set scale to 2 for 2 decimal places
                echo "Downloading DSC0$imagenum, with the file name DSC0$imagenum.jpg, with a file size of $kbsize KB ... File Download Complete!"
                #Echo to the user what the program is doing
                
                wget -P images -q "$imagetodl"
                #Download the image to a folder called images, -q used to not display the process to the user

                echo "PROGRAM FINISHED"
                #Indicate to the user that the program has finished downloading the image

                break

            else
                echo "There was an error finding the specified image, please try again!"
                #In the event that the user enters an incorrect number for the desired image, display an error message to the user
    
            fi

        done

    fi


    if [ $selection = 2 ]; then
    #If the user enters 2; run this function

        while read line; do
        selectedimg=$(sed -e 's%https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/%%; s/.jpg//; s/\n//' <<< $line)
        #while read line will cycle through each line in the given file. A variable selectedimg will be created after stripping the
        #url aspect, the .jpg, and the proceeding line break (\n) from the line, storing only the name of the image
            
        curl -i -s "$line" > imagelength.txt
        lengthline=$(grep -a "Length: ....." imagelength.txt)
        echo "$lengthline" > imagelength.txt
        fsize=$(sed -e 's/Content-Length: //; s/\r//' imagelength.txt)
        kbsize=$(echo "scale=2 ; $fsize / 1024" | bc)
        echo "Downloading $selectedimg with the file name $selectedimg.jpg with a file size of $kbsize KB ... File Download Complete!"
        #This section of code is identical to the code used in function 1 with changed variables. Refer to line 31 to view the explanation
        #of this code

        done < imagelist.txt
        #This is done to bring the content of imagelist.txt into this while loop

        wget -P images -q -i imagelist.txt
        #Download the image to a folder called images, -q used to not display the process to the user

        echo "PROGRAM FINISHED"
        #Indicate to the user that the program has finished downloading the image
    fi


    if [ $selection = 3 ]; then
    #if the user enters 3; run this function

        read -p "Enter the minimum number for the range : " lowerrange
        #Recieve input from the user regarding the lower number of the range, and store it as a variable called lowerrange

        read -p "Enter the maximum number for the range : " upperrange
        #Recieve input from the user regarding the upper number of the range, and store it as a variable named upperrange

        for  (( c=$lowerrange; c<=$upperrange; c++ ))
        #begin a c-styled loop, beginning at the lowerrange, with the max being the upperrange. Increment the c variable value by 1 each loop

        do
            grep "$c" imagelist.txt > rangeimage.txt
            #Retrieve the image value of the c variable value from imagelist.txt, and write it to a file called rangeimage.txt
            
            if grep -q "$c" rangeimage.txt; then
            #Tests if the image in the range actually exists before proceeding
                imageselected=$(grep "$c" rangeimage.txt)
                #Retrieve the URL of the image in the range and store it in a variable called imageselected

                curl -i -s "$imageselected" > imagelength.txt
                lengthline=$(grep -a "Length: ....." imagelength.txt)
                echo "$lengthline" > imagelength.txt
                fsize=$(sed -e 's/Content-Length: //; s/\r//' imagelength.txt)
                kbsize=$(echo "scale=2 ; $fsize / 1024" | bc)
                echo "Downloading DSC0$c, with the file name DSC0$c.jpg, with a file size of $kbsize KB ... File Download Complete!"
                #This section of code is identical to the code used in function 1 with changed variables. Refer to line 31 to view the explanation
                #of this code

                wget -P images -q -i rangeimage.txt
                #Download the image to a folder called images, -q used to not display the process to the user

                

            fi
            
        done
        echo "PROGRAM FINISHED"
        #Indicate to the user that the program has finished downloading the image

            
    fi


    if [ $selection = 4 ]; then
    #if the user enters 4; run this function

        read -p "Enter how many images you would like to download: " randomnum
        shuf -n $randomnum imagelist.txt > randomurls.txt
        #Recieve input from the user about how many random images should be downloaded and store it as a variable named randomnum.
        #Use shuf to select random images from imagelist.txt and write them to a file called randomurls.txt. The randomnum variable is used
        #to determine the amount of random images to be selected and downloaded

        while read line; do
            selectedimg=$(sed -e 's%https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/%%; s/.jpg//; s/\n//' <<< $line)
            #while read line will cycle through each line in the given file. A variable selectedimg will be created after stripping the
            #url aspect, the .jpg, and the proceeding line break (\n) from the line, storing only the name of the image
            
            curl -i -s "$line" > imagelength.txt
            lengthline=$(grep -a "Length: ....." imagelength.txt)
            echo "$lengthline" > imagelength.txt
            fsize=$(sed -e 's/Content-Length: //; s/\r//' imagelength.txt)
            kbsize=$(echo "scale=2 ; $fsize / 1024" | bc)
            echo "Downloading $selectedimg with the file name $selectedimg.jpg with a file size of $kbsize KB ... File Download Complete!"
            #This section of code is identical to the code used in function 1 with changed variables. Refer to line 31 to view the explanation
            #of this code


        done < randomurls.txt
        #This is done to bring the content of imagelist.txt into this while loop

        wget -P images -q -i randomurls.txt
        #Download the image to a folder called images, -q used to not display the process to the user

        echo "PROGRAM FINISHED"
        #Indicate to the user that the program has finished downloading the image

    fi


    if [ $selection = 5 ]; then
    #if the user enters 5; run this function

        echo 'Thank you for using the program!'
        #Thank the user for using the program

        break
        #Break from the main loop
    fi



done
exit 0
#Close the program