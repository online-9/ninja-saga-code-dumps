# Using python 3
# Desc : Download latest version of swf from alan_test_XB42DFH :)
# To do : download using threads
# 		: remove arguments


############## psudo code ################
# 1. create new dir and download all shit in there
# 2. even if current dir exist, just overwrite shit
# 3. ez
# 4. just need simple downloader lulz

import urllib.request
import time
import os
import argparse

# FOR NOW EACH TIME RUN PROGRAM WILL CREATE A NEW DIRECTORY IF NOT EXISTS
# ELSE IT JUST DOWNLOAD STUFF INSIDE THERE

# the game directory you want to download
dir_dl=''
dir_name = "\\alan_test_XB42DFH"

def createDir():
    dir = os.getcwd() + dir_name
    if os.path.exists(dir):
        os.chdir(dir)
    else:
        os.mkdir(dir)
        os.chdir(dir)
        # print(dir)
createDir()

# CUT THIS PART LATER
parser = argparse.ArgumentParser(description='Download files from NS server :)')
parser.add_argument('-a', help='code_library.swf',action='store_true')
parser.add_argument('-b', help='client_library.swf',action='store_true')
parser.add_argument('-c', help='network_library.swf',action='store_true')
parser.add_argument('-d', help='data_library_en.swf',action='store_true')
parser.add_argument('-e', help='library.swf',action='store_true')
parser.add_argument('-f', help='clan_panel.swf',action='store_true')
parser.add_argument('-g', help='ninja_association.swf',action='store_true')

args = parser.parse_args()
# CUT THIS PART LATER

# ALL NECESSARY LINKS (change to keypair array for ez management)
sleepTMR             = 10
link                 = 'https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/'
alan                 = 'https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/alan_test_XB42DFH/'
ninjaassociationlink = alan+'swf/panels/ninja_association.swf'
clanpanellink 		 = alan+'swf/panels/clan_panel.swf'
librarylink          = alan+'swf/library/library.swf'
dataliblink 		 = alan+'swf/language/data_library_en.swf'
networkliblink       = alan+'swf/library/network_library.swf'
clientliblink        = alan+'swf/library/client_library.swf'
codeliblink          = alan+'swf/library/code_library.swf'
gamelink             = alan + 'ninja_saga.swf'

# no need repeat, just use threads

if args.a:
    print('Download code lib')
    try:
        urllib.request.urlretrieve(codeliblink, 'code_library.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'code_library.swf' + " not found")
    time.sleep(sleepTMR)

if args.b:
    print('Download client lib')
    try:
        urllib.request.urlretrieve(clientliblink, 'client_library.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'client_library.swf' + " not found")
    time.sleep(sleepTMR)

if args.c:
    print('Download network lib')
    try:
        urllib.request.urlretrieve(networkliblink, 'network_library.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'network_library.swf' + " not found")

    time.sleep(sleepTMR)
if args.d:
    print('Download data lib')
    try:
        urllib.request.urlretrieve(dataliblink, 'data_library_en.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'data_library_en.swf' + " not found")
    time.sleep(sleepTMR)

if args.e:
    print('Download lib')
    try:
        urllib.request.urlretrieve(dataliblink, 'data_library_en.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'data_library_en.swf' + " not found")
    time.sleep(sleepTMR)

if args.f:
    print('Download clan panel')
    try:
        urllib.request.urlretrieve(clanpanellink, 'clan_panel.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'clan_panel.swf' + " not found")
    time.sleep(sleepTMR)

if args.g:
    print('Download ninja association')
    try:
        urllib.request.urlretrieve(ninjaassociationlink, 'ninja_association.swf') # URL, FILENAME
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("File " + 'ninja_association.swf' + " not found")
    time.sleep(sleepTMR)