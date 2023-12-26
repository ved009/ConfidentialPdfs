#!/bin/bash

#Collect Pdf Files using Gau
cat subdomains.txt | gau --subs --threads 20 | grep -Ea '.pdf' | tee pdfs.txt

#Find Alive Pdf Files
cat pdfs.txt | httpx -silent -mc 200 | tee alivepdfs.txt

#Loop through each line in the alivepdfs.txt file
while IFS= read -r url; do
    # Download the PDF file using wget with defined Timeout
    wget "$url" -O temp.pdf --no-check-certificate --timeout=10

    # Convert the PDF to text
    pdftotext temp.pdf temp.txt

    # Search for the specified strings in the converted text file, can also add more strings to check 
    if grep -qE "Internal use only|Confidential" temp.txt; then
        # If found, append the URL to the leaks.txt file
        echo "$url" >> leaks.txt
    fi

    # Clean up temporary files
    rm temp.pdf temp.txt
done < alivepdfs.txt
