#! /bin/bash

# Authur: Majiri Eyowel
# Email: majirieyowel@gmail.com
# Date: Fri  6 Nov 2020 14:28:12 WAT
# Licence: MIT
# Description: A simple script to make creating admin pannels faster using laravel 8 PHP framework

#File base path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#Laravel paths
_CONTROLLER_PATH="./app/Http/Controllers/Admin"
_MODELS_PATH="./app/Models"
_VIEW_PATH="./resources/views/admin"
_REQUEST_PATH="./app/Http/Requests"

# Get root of laravel project
LARAVEL_ROOT_DIRECTORY=$1

if [ -z "$LARAVEL_ROOT_DIRECTORY" ]
then
    read -p "Laravel Project Root Directory: " LARAVEL_ROOT_DIRECTORY
fi

# Validate input is not empty
if [ -z "$LARAVEL_ROOT_DIRECTORY" ]
then
    echo -e "\033[31m Inputs cannot be blank please try again! \033[0m" 1>&2
    exit 1
fi

# Validate input is a directory
if [ ! -d $LARAVEL_ROOT_DIRECTORY ]; then
    echo -e "\033[31m $LARAVEL_ROOT_DIRECTORY is not a valid directory \033[0m" 1>&2
    exit 1
fi

# Verify laravel project
if [ ! -d "$LARAVEL_ROOT_DIRECTORY/app" ] || [ ! -d "$LARAVEL_ROOT_DIRECTORY/database" ]
then
    echo -e "\033[31m Directory is not a laravel project root. \033[0m" 1>&2
    exit 1
fi

read -p "Model Name (E.g Account): " MODEL

# Validate model input is not empty
if [ -z "$MODEL" ]
then
    echo -e "\033[31m  Model name cannot be blank please try again! \033[0m" 1>&2
    exit 1
fi


# Enter laravel directory
cd $LARAVEL_ROOT_DIRECTORY

if [ -s "${_MODELS_PATH}/${MODEL}.php" ];
then
    echo -e "\033[31m  Model already exists \033[0m" 1>&2
    exit 1
fi

CONTROLLER="${MODEL}Controller"

# option create model && migration
while true; do
    read -p "Do you wish create migration for model $MODEL? " shouldCreateMigration
    case $shouldCreateMigration in
        [Yy]* )
            
            php artisan make:model $MODEL -m
            break
        ;;
        [Nn]* )
            php artisan make:model $MODEL
            break
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done

# option to create mock resourceful views
while true; do
    read -p "Do you wish create admin views? " shouldCreateAdminViews
    case $shouldCreateAdminViews in
        [Yy]* )
            #If admin folder don't exist create it
            if [ ! -d "${_VIEW_PATH}" ]
            then
                mkdir -p ${_VIEW_PATH}
            fi
            
            LOWERCASE_PATH=`echo "$MODEL" | awk '{print tolower($0)}'`
            
            if [ ! -d "${_VIEW_PATH}/${LOWERCASE_PATH}" ]
            then
                mkdir -p "${_VIEW_PATH}/${LOWERCASE_PATH}"
                
                # resourceful views
                array=( 'index' 'create' 'show' 'edit' )
                for i in "${array[@]}"
                do
                    touch "${_VIEW_PATH}/${LOWERCASE_PATH}/$i.blade.php"
                done
                
                #Make the files executable recursively (alternatively chmod +x <filepath>)
                chmod -R 755 "${_VIEW_PATH}/${LOWERCASE_PATH}"
                
                # option to populate files with specfied layout
                while true; do
                    read -p "Do you wish to copy view template (Please edit layout template before accepting)? " shouldExtendLayout
                    case $shouldExtendLayout in
                        [Yy]* )
                            
                            #Populate files here
                            array=( 'index' 'create' 'show' 'edit' )
                            for i in "${array[@]}"
                            do
                                cat ${DIR}/templates/layout/${i}Template.html > ./${_VIEW_PATH}/${LOWERCASE_PATH}/$i.blade.php
                                echo "copied $i view successfully"
                            done
                            
                            break
                        ;;
                        [Nn]* )
                            break
                        ;;
                        * ) echo "Please answer yes or no.";;
                    esac
                done
                
            else
                echo -e "\033[31m  Admin path already exist - Manually inspect it..." 1>&2
                echo -e "\033[0m"
            fi
            break
        ;;
        [Nn]* )
            break
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done

#Addional Params for controller creation
DATE=`date +"%m-%d-%Y"`
STORE_REQUEST="${MODEL}StoreRequest"
EDIT_REQUEST="${MODEL}UpdateRequest"

RMODEL=`echo "$MODEL" | awk '{print tolower($0)}'`
temp_request_name=temp_request.php
CONTROLLER_TEMPLATE=controllerTemplate.php
TEMPORAL_TEMPLATE_FILE=_temporalController.php # Because I can't find a way to edit a text stream and save on the fly on the same document.

#Make a resourceful controller

# copy template file to laravel root
cp "${DIR}/templates/controller/${CONTROLLER_TEMPLATE}" ./${CONTROLLER_TEMPLATE}

STORE_REQUEST_FILE="${MODEL}StoreRequest.php"
EDIT_REQUEST_FILE="${MODEL}UpdateRequest.php"


php artisan make:request ${STORE_REQUEST}
php artisan make:request ${EDIT_REQUEST}

# Set authorization to true in request files
if [ -d "${_REQUEST_PATH}" ]
then
    
    sed s/false/true/ "${_REQUEST_PATH}/${STORE_REQUEST_FILE}" > ${_REQUEST_PATH}/${temp_request_name}
    rm -f "${_REQUEST_PATH}/${STORE_REQUEST_FILE}"
    mv ${_REQUEST_PATH}/${temp_request_name} ${_REQUEST_PATH}/${STORE_REQUEST_FILE}
    
    sed s/false/true/ ${_REQUEST_PATH}/${EDIT_REQUEST_FILE} > ${_REQUEST_PATH}/${temp_request_name}
    rm -f "${_REQUEST_PATH}/${EDIT_REQUEST_FILE}"
    mv ${_REQUEST_PATH}/${temp_request_name} ${_REQUEST_PATH}/${EDIT_REQUEST_FILE}
fi

# Controller
sed s/_CONTROLLER/${CONTROLLER}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}

# # Date
sed s/_DATE/${DATE}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}

# #Model
sed s/_MODEL/${MODEL}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}

# #Create Request
sed s/_STORE_REQUEST/${STORE_REQUEST}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}

# #Edit Request
sed s/_EDIT_REQUEST/${EDIT_REQUEST}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}

# #Lowercase route Model
sed s/_RMODEL/${RMODEL}/g ./${CONTROLLER_TEMPLATE} > ${TEMPORAL_TEMPLATE_FILE}
rm -f "./${CONTROLLER_TEMPLATE}"
mv ./${TEMPORAL_TEMPLATE_FILE} ./${CONTROLLER_TEMPLATE}


#If controller folder don't exist create it
if [ ! -d "${_CONTROLLER_PATH}" ]
then
    mkdir -p ${_CONTROLLER_PATH}
fi

# move template to appropriate location

mv ./${CONTROLLER_TEMPLATE} "./${_CONTROLLER_PATH}/${CONTROLLER}.php"

echo -e "\033[33m Generator finished"
echo -e "\033[33m Model Name: $MODEL"
echo -e "\033[33m Model Path: $_MODELS_PATH"
echo -e "\033[33m Controller Name: $CONTROLLER"
echo -e "\033[33m Controller Path: $_CONTROLLER_PATH"
echo -e "\033[0m"