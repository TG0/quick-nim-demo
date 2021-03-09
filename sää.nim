# Just a quick demo app on the Nim language suntax
# The program shows the current temperature reading in a given finnish town
# The temperature info is got from Iltalehti.fi

# Compile:
# nim -d:ssl --passc:-flto c sää.nim

import httpClient
import strutils
import times
import os
import uri


let pars = commandLineParams()

if "-h" in pars or "-help" in pars:
  echo "\nKäyttö: \n\nsää2.exe \"särkilahti, turku\" \n\ntai: \n\nsää2.exe tampere"
  quit(0)


let town = pars[0]  

let oClient = newHttpClient()

let sSiteData = oClient.getContent("https://www.iltalehti.fi/saa/Suomi/" & encodeUrl(town) & "/")


var seqData = newSeq[string]()

let sTime = " (" & local(getTime()).format("HH:mm:ss") & ")\n"


for sLine in sSiteData.split("</div>"):

  if sLine.find("\"current\">") > -1:          # <div class="current">-8<!-- -->°

    seqData = sLine.split("\"current\">")     

    echo "\n\nLämpötila on: " & seqData[1].strip().replace("<!-- -->", "") & sTime 
    
    quit(0)