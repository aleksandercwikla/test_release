#!/bin/bash

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# current project name
projectName=$(git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p')

masterBranch=master

# checkout to master branch, this will break if the user has uncommited changes
git checkout $masterBranch

# master branch validation
if [ $branch = "master" ]; then
	echo "Enter the release version number"

	read versionNumber

	# v1.0.0, v1.7.8, etc..
  export VERSION=$versionNumber
	versionLabel=v$versionNumber
	releaseBranch=master_release

	echo "Started releasing $versionLabel for $projectName ....."

	# pull the latest version of the code from master
	git pull

	# create empty commit from master branch, create release_branch
	git commit --allow-empty -m "Creating Branch $releaseBranch"

	# create tag for new version from -master
	git tag $versionLabel

	# push commit to remote origin
	git push

	# push tag to remote origin
	git push --tags origin

	# create the release branch from the -master branch
  git checkout -b $releaseBranch $masterBranch

	# checkout to master branch
	git checkout $masterBranch

  # push local releaseBranch to remote
	git push -u origin $releaseBranch

	echo "$versionLabel is successfully released for $projectName ...."

	# checkout to master branch
	git checkout $masterBranch

	# pull the latest version of the code from master
	git pull

	echo "Bye!"

else
	echo "Please make sure you are on master branch and come back!"
	echo "Bye!"
fi

echo "Click something to exit"
read someKey