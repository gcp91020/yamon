#!/bin/bash

# baseDir=$(cd "$(dirname "$0")" && pwd)
baseDir=$(pwd)
echo $baseDir

if [ "$baseDir"=="/Users/$USER/Temp" ]; then
	if [ ! -d /Users/$USER/Temp/yamon ]; then
		mkdir /Users/$USER/Temp/yamon
	fi
fi

cd /Users/yxiao/Temp/yamon

function generate_data(){
	_date=$(date +"%Y/%m")
	[ ! -d "${baseDir}/data/${_date}" ] && mkdir -p "${baseDir}/data/${_date}"
	_date_1=$(date +"%Y-%m-%d")
	[ ! -f "${baseDir}/data/${_date}/hourly_${_date_1}.js" ] && cp "${baseDir}/data/hourly_template.js" "${baseDir}/data/${_date}/hourly_${_date_1}.js"
	_date_2=$(date +"%Y-%m")
	[ ! -f "${baseDir}/data/${_date}/${_date_2}-mac_usage.js" ] && cp "${baseDir}/data/mac_usage_template.js" ""${baseDir}/data/${_date}/${_date_2}-mac_usage.js""
}


if [ ! -f ~/.ssh/config ]; then 
	touch ~/.ssh/config
fi
if ! grep "Host github.com" ~/.ssh/config > /dev/null ; then
echo "Host github.com
	Hostname github.com
	IdentityFile ~/Keys/key0226.pem
	IdentitiesOnly yes
" > ~/.ssh/config
fi

if [ ! -f .git/config ]; then
	echo "Are you sure to clone the repository yamon to $(pwd)? (Y/N) default=Y"
	read input
	if [ -z $input ]; then 
		clone=Y 
	fi
	if [[ "$input" =~ ^[Yy].* ]]; then
		clone=Y	
	fi
	if [[ $clone == "Y" ]]; then
		git init
		git config --global user.name "gcp91020"
		git config --global user.email "gcp91020@gmail.com"
		git remote add yamon git@github.com:gcp91020/yamon.git
		git pull yamon main
		[ ! -d webroot ] && mkdir webroot
		[ ! -f yamon ] && ln -s webroot yamon
		[ ! -d data ] && mkdir data
		[ ! -f www/data4 ] && ln -s ../data www/data4
	fi
else
	if grep "url = git@github.com:gcp91020/yamo.git" .git/config ; then
		echo "yamon.git exists"
	else
		repository=$(grep "url = git@github.com" .git/config)
		echo "Current repository is $repository"
 	fi

fi

generate_data
find "${baseDir}"/ -name  ".DS_Store" -delete

echo "
git add --all
git add data
git rm -r .idea
git rm .gitignore
find "${baseDir}"/ -name  ".DS_Store" -delete
find ./ -name  ".DS_Store" -delete
git commit -a
git commit -m \"update\"
git push yamon main
"


#vi ~/.ssh/config
#	Hostname github.com
#	IdentityFile ~/Keys/key0226.pem
#	IdentitiesOnly yes
#	https://github.com/settings/keys
#

# git init
# git remote add origin git@github.com:gcp91020/yamon.git
# git pull origin main

# git add localinit.sh
# git commit -a
# git push origin main
# edit username and hostname
# git config --global --edit 
# git commit --amend --reset-author

#create a new repository

# git init
# git remote add origin git@github.com:gcp91020/yamon.git
# git branch -M main
# copy files
# edit .gitignore .idea .DS_Store .git data
# git add data xxx
# git add --all
# git commit -m "updated"
# git push -u yamon main

# git checkout -b master

# python3 -m http.server