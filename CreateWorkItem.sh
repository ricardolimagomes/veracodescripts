#!/bin/bash

echo Start
cd $(Build.ArtifactStagingDirectory) || true
rm file.txt || true
rm results.txt || true
wget $(results.remoterepo)
cat results.txt

echo 'Start Procedure'

#Create a Text File with all occurrences
grep 'CWE' results.txt > file.txt

# Set Number of Work Item to create
#ISSUESNUMBER = $(grep -o -i CWE file.txt | wc -l) || true

while read -r line; do

        echo -------------------------Start Requests to Create Work Item--------------------------------------
        echo $line
        curl --location --request POST 'https://dev.azure.com/$(organization)/$(project)/_apis/wit/workitems/$Task?api-version=6.0' \
        --header 'Content-Type: application/json-patch+json' \
        --header 'Authorization: Basic $PAT64' \
        --data-raw '[
          {
            "op": "add",
            "path": "/fields/System.Title",
            "from": null,
            "value": "'"$line"'"
          }
        ]'


done < file.txt

echo Finish Creating WorkItems
