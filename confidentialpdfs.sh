#!/bin/bash

cat subdomains.txt | gau --subs --threads 20 | grep -Ea '\\.pdf' | tee pdfs.txt
cat pdfs.txt | httpx -silent -mc 200 | alivepdfs.txt

#Loop through each line in the alivepdfs.txt file
while IFS= read -r url; do
    # Download the PDF file using wget or curl
    wget "$url" -O temp.pdf || curl -o temp.pdf "$url"

    # Convert the PDF to text
    pdftotext temp.pdf temp.txt

    # Search for the specified strings in the converted text file
    if grep -qE "internal use only|Confidential" temp.txt; then
        # If found, append the URL to the leaks.txt file
        echo "$url" >> leaks.txt
    fi

    # Clean up temporary files
    rm temp.pdf temp.txt
done < alivepdfs.txt
