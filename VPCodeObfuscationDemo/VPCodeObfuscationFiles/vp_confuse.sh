#!/bin/sh

#  vp_confuse.sh
#  VPCodeObfuscationDemo
#
#  Created by Axe on 2018/3/21.
#  Copyright © 2018年 Axe. All rights reserved.
#  Run Script: $PROJECT_DIR/VPCodeObfuscationFiles/vp_confuse.sh
#  cd VPCodeObfuscationFiles: chmod 755 vp_confuse.sh

# The root directory
ROOT_FOLDER="$PROJECT_DIR"

# Filename prefix
FILE_NAME_PREFIX="vp"
FILE_NAME_PREFIX_CAPITAL=`echo $FILE_NAME_PREFIX | tr [a-z] [A-Z]`

# The root directory of the script
CONFUSE_ROOT_FILE="$ROOT_FOLDER/VPCodeObfuscationFiles"

# Confuse the macro definition file
HEAD_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX_CAPITAL}CodeConfuscationMacros.h"

#waring This file lists the reserved keywords of the Apple system API and does not recommend deleting the text file.
RESERVEDKEYWORDS="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_reservedKeywords.list"

STRING_SYMBOL_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_func.list"

# SQLite_DB
TABLE_NAME=symbols
SYMBOL_DB_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_symbols.db"

RES_CUSTOM_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_resCustom.list"
REP_CUSTOM_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_repCustom.list"

SPECIFIED_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_specifiedFile.list"
EXCLUDE_FILE="$CONFUSE_ROOT_FILE/${FILE_NAME_PREFIX}_excludeFile.list"

export LC_CTYPE=C

ramdomString() {
	openssl rand -base64 64 | tr -cd 'a-zA-Z0-9' | sed 's/^[0-9]*//g' | head -c 16
}

createDatabase() {
	echo "create table $TABLE_NAME(src text, des text, date text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue() {
	echo "insert into $TABLE_NAME values('$1' ,'$2' ,'$3');" | sqlite3 $SYMBOL_DB_FILE
}

if [ ! -f $RESERVEDKEYWORDS ]
then
touch $RESERVEDKEYWORDS
fi

if [ ! -f $STRING_SYMBOL_FILE ]
then
touch $STRING_SYMBOL_FILE
fi

## Custom reserved file list
if [ ! -f $RES_CUSTOM_FILE ]
then
touch $RES_CUSTOM_FILE
fi

## Custom obfuscation file list
if [ ! -f $REP_CUSTOM_FILE ]
then
touch $REP_CUSTOM_FILE
fi

## Specified file list
if [ ! -f $SPECIFIED_FILE ]
then
touch $SPECIFIED_FILE
fi

## Exclude file list
if [ ! -f $EXCLUDE_FILE ]
then
touch $EXCLUDE_FILE
fi

## Default exclude file
rm -f exclude_default_file.txt
arr=($(basename $CONFUSE_ROOT_FILE) *.framework *.xcodeproj *.storyboard *.swift *.mm *.xib include libraries Libs lib)
for data in ${arr[@]}
do
echo $data >> exclude_default_file.txt
done

## User add exclude file
if [ ! -f exclude_added_file.txt ]
then
touch exclude_added_file.txt
else
rm -f exclude_added_file.txt
fi

cat $EXCLUDE_FILE |
while read line
do
echo $line >> exclude_added_file.txt
done

rm -f exclude_file_tmp.txt
cat exclude_default_file.txt exclude_added_file.txt | sort | uniq | sed '/^$/d' > exclude_file_tmp.txt
rm -f exclude_default_file.txt
rm -f exclude_added_file.txt

rm -f exclude_file.txt
rm -f $EXCLUDE_FILE

cat exclude_file_tmp.txt |
while read line
do
echo $line >> $EXCLUDE_FILE
echo "--exclude-dir=$line" >> exclude_file.txt
done
rm -f exclude_file_tmp.txt

for line in `cat exclude_file.txt`
do
EXCLUDE_DIR="$EXCLUDE_DIR $line"
done

#echo EXCLUDE_DIR: $EXCLUDE_DIR

rm -f exclude_file.txt

## File Paths
rm -f filePaths.txt

if [ -s $SPECIFIED_FILE ]
then
cat $SPECIFIED_FILE |
while read filename
do
if [[ $filename =~ "." ]]
then
find $ROOT_FOLDER -name "$filename" -type f | sed "/\/\./d" >> filePaths.txt
else
find $ROOT_FOLDER -name "$filename.h" -o -name "$filename.m" -type f | sed "/\/\./d" >> filePaths.txt
fi
done
fi

rm -f classPaths.txt
rm -f funcPaths.txt
rm -f propertyPaths.txt
rm -f protocolPaths.txt

if [ -s filePaths.txt ]
then
cat filePaths.txt |
while read filepath
do
grep -h -r -I "^@interface" $filepath >> classPaths.txt
grep -h -r -I "^[-+]"       $filepath >> funcPaths.txt
grep -h -r -I "^@property"  $filepath >> propertyPaths.txt
grep -h -r -I "^@protocol"  $filepath >> protocolPaths.txt
done
else ## empty file
grep -h -r -I "^@interface" $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > classPaths.txt
grep -h -r -I "^[-+]"       $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > funcPaths.txt
grep -h -r -I "^@property"  $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > propertyPaths.txt
grep -h -r -I "^@protocol"  $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > protocolPaths.txt
fi

rm -f filePaths.txt

## property list
rm -f filter_property.txt
grep -v "IBOutlet" propertyPaths.txt | sed 's/;.*//g' | sed "s/( *^/ /g" | sed "s/) *(/{/g" | sed "s/{.*)/ /g" | sed "s/(.*)/ /g" | sed "s/<.*>//g" | sed "s/[,*]/ /g" | sed 's/[ ][ ]*/ /g' | awk -F " " '{print $NF}' | sort | uniq | sed '/^$/d' > filter_property.txt
rm -f propertyPaths.txt

rm -f all_property_path.txt
grep -h -r -I "^@property"  $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > all_property_path.txt
rm -f property_with_iboutlet.txt
grep "IBOutlet" all_property_path.txt | sed 's/;.*//g' | sed "s/( *^/ /g" | sed "s/) *(/{/g" | sed "s/{.*)/ /g" | sed "s/(.*)/ /g" | sed "s/<.*>//g" | sed "s/[,*]/ /g" | sed 's/[ ][ ]*/ /g' | awk -F " " '{print $NF}' | sort | uniq | sed '/^$/d' > property_with_iboutlet.txt
rm -f all_property_path.txt

## function list

rm -f func_proxy.txt
grep -v "IBAction" funcPaths.txt | sed 's/;.*//g' | sed 's/[{}]/ /g' | sed 's/[-+]//g' | sed 's/^[ ]*//g' | sed 's/[ ]*$//g' | sed 's/([^)]*)*//g' | sed 's/[ ][ ]*/ /g' | sed 's/ *: */:/g' | sed 's///g' | sed "/^init/d"| sort | uniq | sed '/^$/d' > func_proxy.txt
rm -f funcPaths.txt

rm -f func_proxy_tmp.txt
cat func_proxy.txt |
while read line
do
OLD_IFS="$IFS"
IFS=" "
arr=($line)
IFS="$OLD_IFS"
for data in ${arr[@]}
do
first_data=`echo $data | awk -F ":" '{print $1}'`
echo $first_data >> func_proxy_tmp.txt
done
done
rm -f func_proxy.txt

rm -f filter_func.txt
cat func_proxy_tmp.txt | sort | uniq | sed '/^$/d' > filter_func.txt
rm -f func_proxy_tmp.txt

rm -f all_func_path.txt
grep -h -r -I "^[-+]" $ROOT_FOLDER $EXCLUDE_DIR --include '*.[mh]' > all_func_path.txt

rm -f func_with_ibaction_proxy.txt
grep "IBAction" all_func_path.txt | sed 's/;.*//g' | sed 's/[{}]/ /g' | sed 's/[-+]//g' | sed 's/^[ ]*//g' | sed 's/[ ]*$//g' | sed 's/([^)]*)*//g' | sed 's/[ ][ ]*/ /g' | sed 's/ *: */:/g' | sed 's///g' | sed "/^init/d"| sort | uniq | sed '/^$/d' > func_with_ibaction_proxy.txt
rm -f all_func_path.txt

if [ ! -f func_with_ibaction.txt ]
then
touch func_with_ibaction.txt
else
rm -f func_with_ibaction.txt
fi

cat func_with_ibaction_proxy.txt |
while read line
do
OLD_IFS="$IFS"
IFS=" "
arr=($line)
IFS="$OLD_IFS"
for data in ${arr[@]}
do
first_data=`echo $data | awk -F ":" '{print $1}'`
echo $first_data >> func_with_ibaction.txt
done
done
rm -f func_with_ibaction_proxy.txt

## class name list
rm -f filter_class_tmp.txt
cat classPaths.txt | sed "s/[:(]/ /" | awk '{split($0,s," ");print s[2];}' | sort | uniq | sed '/^$/d' >> filter_class_tmp.txt  ## class
rm -f classPaths.txt

rm -f filter_class.txt
cat filter_class_tmp.txt |
while read class_name
do
rm -f class_tmp.txt
if grep -r -n -I -w "$class_name" $ROOT_FOLDER $EXCLUDE_DIR   --include="*.c" --include="*.mm" --include="*.storyboard" --include="*.xib" > class_tmp.txt
then
cat class_tmp.txt |
while read ts
do
v1=$(echo "$ts"|cut -d: -f 1 )
v2=$(echo "$ts"|cut -d: -f 2 )
echo "Find class: $class_name at $(basename $v1) line:$v2"
done
else
echo $class_name >> filter_class.txt
fi
done
rm -f class_tmp.txt

rm -f filter_class_tmp.txt

## protocol name list
rm -f filter_protocol.txt
cat protocolPaths.txt | sed "s/[\<,;].*$//g" | awk '{print $2;}' | sed 's/[[:space:]]//g' | sort | uniq | sed "/^$/d" >> filter_protocol.txt ## protocol
rm -f protocolPaths.txt

##############################################################################################

## Generate `Setter` method names based on properties.
if [ ! -f property_setter_func.txt ]
then
touch property_setter_func.txt
else
rm -f property_setter_func.txt
fi

cat filter_property.txt |
while read property
do
first_property=`echo $property | cut -c -1 | tr [a-z] [A-Z]`
without_first_property=`echo $property | cut -c 2-`
setter_func=`echo set$first_property$without_first_property`
echo $setter_func >> property_setter_func.txt
done

if [ ! -f filter_func_without_getter_and_setter.txt ]
then
touch filter_func_without_getter_and_setter.txt
else
rm -f filter_func_without_getter_and_setter.txt
fi

## Merge filter_func.txt, filter_class.txt, filter_protocol.txt
if [ ! -f without_property_derive.txt ]
then
touch without_property_derive.txt
else
rm -f without_property_derive.txt
fi

cat filter_func.txt filter_class.txt filter_protocol.txt $REP_CUSTOM_FILE | sort | uniq | sed "/^$/d" >> without_property_derive.txt
rm -f filter_func.txt
rm -f filter_class.txt
rm -f filter_protocol.txt

rm -f getter_setter_ibaction.txt
cat filter_property.txt property_setter_func.txt func_with_ibaction.txt | sort | uniq | sed "/^$/d" >> getter_setter_ibaction.txt
rm -f property_setter_func.txt
rm -f func_with_ibaction.txt

cat without_property_derive.txt |
while read line
do
if grep "$line\>" getter_setter_ibaction.txt
then
echo Find_Getter_Setter_IBAction: $line
else
random=`ramdomString`
echo "$line $random" >> filter_func_without_getter_and_setter.txt ## function
fi
done
rm -f without_property_derive.txt
rm -f getter_setter_ibaction.txt

if [ ! -f repProperty.txt ]
then
touch repProperty.txt
else
rm -f repProperty.txt
fi

cat filter_property.txt |
while read line
do
if grep "$line\>" property_with_iboutlet.txt $RESERVEDKEYWORDS $RES_CUSTOM_FILE
then
echo Find_Property_IBOutlet: $line
else
random=`ramdomString`
echo "$line $random" >> repProperty.txt ## property
fi
done

rm -f filter_property.txt
rm -f property_with_iboutlet.txt

if [ ! -f var_property.txt ]
then
touch var_property.txt
else
rm -f var_property.txt
fi

cat repProperty.txt |
while read line
do
ar=(`echo "$line"|cut -d " " -f 1-2`)
_property=`echo _${ar[0]}`
_random=`echo _${ar[1]}`
rm -f var_tmp.txt
if grep -r -n -I -w "$_property" $ROOT_FOLDER $EXCLUDE_DIR --include="*.[mhc]" --include="*.mm" > var_tmp.txt
then
cat var_tmp.txt |
while read ts
do
v1=$(echo "$ts"|cut -d: -f 1 )
v2=$(echo "$ts"|cut -d: -f 2 )
echo "Find $_property at $(basename $v1) line:$v2"
echo "$_property $_random" >> var_property.txt  ## var_property
done
else
echo "Do not find $_property"
fi
done
rm -f var_tmp.txt

if [ ! -f set_property.txt ]
then
touch set_property.txt
else
rm -f set_property.txt
fi

cat repProperty.txt |
while read line
do
ar=(`echo "$line"|cut -d " " -f 1-2`)
property=`echo ${ar[0]}`
random=`echo ${ar[1]}`
first_property=`echo $property | cut -c -1 | tr [a-z] [A-Z]`
first_random=`echo $random | cut -c -1 | tr [a-z] [A-Z]`
without_first_property=`echo $property | cut -c 2-`
without_first_random=`echo $random | cut -c 2-`
setter_property=`echo set$first_property$without_first_property`
setter_random=`echo set$first_random$without_first_random`
rm -f setter_tmp.txt
if grep -r -n -I -w "$setter_property" $ROOT_FOLDER $EXCLUDE_DIR --include="*.[mhc]" --include="*.mm" > setter_tmp.txt
then
cat setter_tmp.txt |
while read ts
do
v1=$(echo "$ts"|cut -d: -f 1 )
v2=$(echo "$ts"|cut -d: -f 2 )
echo "Find $setter_property at $(basename $v1) line:$v2"
echo "$setter_property $setter_random" >> set_property.txt ## set_property
done
else
echo "Do not find $setter_property"
fi
done
rm -f setter_tmp.txt

rm -f rep_keys_all.txt
cat filter_func_without_getter_and_setter.txt repProperty.txt set_property.txt var_property.txt | sort | uniq | sed '/^$/d' > rep_keys_all.txt
rm -f filter_func_without_getter_and_setter.txt
rm -f repProperty.txt
rm -f set_property.txt
rm -f var_property.txt

rm -f res_keys_all.txt
cat $RESERVEDKEYWORDS $RES_CUSTOM_FILE | sort | uniq | sed '/^$/d' > res_keys_all.txt

rm -f $STRING_SYMBOL_FILE
rm -f $HEAD_FILE

symbol_file_h="_h"
macros_file_name=`echo $(basename $HEAD_FILE .h)$symbol_file_h`

echo "#ifndef $macros_file_name
#define $macros_file_name" >> $HEAD_FILE
echo "" >> $HEAD_FILE
echo "/// The $(basename $HEAD_FILE) file be created by ${FILE_NAME_PREFIX}_confuse.sh shell at `date '+%Y-%m-%d %H:%M:%S'` by Axe." >> $HEAD_FILE
echo "" >> $HEAD_FILE

createDatabase

cat rep_keys_all.txt |
while read line
do
key=`echo $line | cut -d " " -f 1`
value=`echo $line | cut -d " " -f 2`
if grep "$key\>" res_keys_all.txt
then
echo Filtering systems or custom keywords: $key
else
date=`date '+%Y-%m-%d %H:%M:%S'`
insertValue $key $value "$date"
echo $key >> $STRING_SYMBOL_FILE
echo "#define $line" >> $HEAD_FILE
fi
done

echo "" >> $HEAD_FILE
echo "#endif /* $macros_file_name */" >> $HEAD_FILE

sqlite3 $SYMBOL_DB_FILE .dump

rm -f rep_keys_all.txt
rm -f res_keys_all.txt

exit
