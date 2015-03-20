#!/bin/bash

# $1 = JIRA project ID, like PARANAMER
# $2 = mac number of issues within that, like 26

function get_page_and_unzip {
	URL="$1"
	TO="$2"
	DIR="$3"
    jruby ../firefoxPageSaveViaMaff.rb "$URL" "$TO"
    while [ ! -f "$DIR.maff" ]; do sleep 2; done
	ts=$(unzip "$DIR.maff" | grep "/index.html  $" | sed "s/  inflating: //" | sed "s#/index.html  ##")
	rm "$DIR.maff"
	mv "$ts" "$DIR"
	rm "$DIR/index.rdf"
}

function kill_header {
	DIR="$1"
    perl -pi -e 's/<header id="header"/<header id="header" style="display:none"/' "${DIR}/index.html"
}

function kill_temporal_bits {
	DIR="$1"
    perl -pi -e 's/ASESSIONID : (.*)//' "${DIR}/index.html"
	perl -pi -e 's/REQUEST TIME : (.*)//' "${DIR}/index.html"
	perl -pi -e 's/REQUEST TIMESTAMP : (.*)//' "${DIR}/index.html"
	perl -pi -e 's/REQUEST ID : (.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)jira.request.start.millis(.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)jira.request.server.time(.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)jira.request.id(.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)jira.session.expiry.time(.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)db.reads : name=db.reads; in(.*)//' "${DIR}/index.html"
	perl -pi -e 's/(.*)db.conns : name=db.conns; inv(.*)//' "${DIR}/index.html"
	perl -pi -e 's/^<meta id="atlassian-token(.*)"//' "${DIR}/index.html"
	perl -pi -e 's/(.*)<input id="jiraConcurrentRequests(.*)//' "${DIR}/index.html"
	perl -pi -e 's/^<meta name=(.*)//' "${DIR}/index.html"

}

function kill_navigation_aids {
	DIR="$1"
    perl -pi -e 's/<a id="ops-login-lnk"/<a id="ops-login-lnk" style="display:none"/' "${DIR}/index.html"
    perl -pi -e 's/id="opsbar-jira.issue.tools"/id="opsbar-jira.issue.tools" style="display:none"/' "${DIR}/index.html"
    perl -pi -e 's/<div class="tabwrap tabs2">/<div class="tabwrap tabs2" style="display:none">/' "${DIR}/index.html"
}


[ ! -d work ] && mkdir work
baseDir=$(pwd)
cd work

GH_REPO="$1"
PROJ="$2"
MAXNUM="$3"

# in case you have to manually restart...
#for num in {700..770}

for num in $(seq 1 $MAXNUM)
do
	get_page_and_unzip "https://jira.codehaus.org/browse/${PROJ}-${num}" "$baseDir/work/${num}" "${num}" 
    kill_header "${num}"
    kill_temporal_bits "${num}"
    kill_navigation_aids "${num}"
done


get_page_and_unzip "https://jira.codehaus.org/sr/jira.issueviews:searchrequest-printable/temp/SearchRequest.html?jqlQuery=project+%3D+${PROJ}&tempMax=1000" "$baseDir/work/INDEX" "INDEX" 

# get_page_and_unzip "https://jira.codehaus.org/browse/${PROJ}-${MAXNUM}?jql=project%20%3D%20${PROJ}" "$baseDir/work/INDEX" "INDEX"

mv INDEX/index.html .
mv INDEX/index_files .
rm -rf INDEX

kill_header .
kill_temporal_bits .
kill_navigation_aids .

rm -rf $(ack -l "<h1>Issue Does Not Exist</h1>" | sed 's/index.html//' | xargs)

# Still used?
perl -pi -e 's#<header id="header"#<header id="header" role="banner">Note: JIRA Issues exported from Codehaus - Mar 2015</header><header id="headerO"#' index.html

# hide a few things, as interactivity has gone now.
perl -pi -e 's/class="list-ordering"/class="list-ordering" style="display:none"/g' index.html
perl -pi -e 's/class="aui-page-header-actions"/class="aui-page-header-actions" style="display:none"/g' index.html
perl -pi -e 's/style="width: 200px;" class="navigator-sidebar/style="width: 200px; display:none" class="navigator-sidebar/g' index.html
perl -pi -e 's/class="navigator-search"/class="navigator-search" style="display:none"/g' index.html
perl -pi -e 's/class="saved-search-selector"/class="saved-search-selector" style="display:none"/g' index.html
perl -pi -e 's/id="previous-view"/id="previous-view" style="display:none"/g' index.html


# Remove some things that change per page rendition (and would make repeated saving have noisy diffs)
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e 's#\?page=com.atlassian.jira.plugin.system.issuetabpanels:worklog-tabpanel##g' {}
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e 's#\?page=com.atlassian.jira.plugin.system.issuetabpanels:changehistory-tabpanel##g' {}
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e 's#\?page=com.atlassian.streams.streams-jira-plugin:activity-stream-issue-tab##g' {}
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e 's#\?page=com.atlassian.jira.plugin.system.issuetabpanels:all-tabpanel##g' {}
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e 's#\?page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel##g' {}

find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e "s#https://jira.codehaus.org/browse/${PROJ}-#/${GH_REPO}/#g" {}
find . -name "index.html" -print0 | xargs -0 -I {} perl -p -i -e "s#https://jira.codehaus.org/browse/${PROJ}#/${GH_REPO}/index.html#g" {}

# Remove orphaned > that's the result of some other sed operation that wasn't quite right.
perl -p -i -e 's/^>$//' `find ./ -name *.html`

touch .nojekyll

# couldn't get this working. I mean I could but 
# gh-pages broke during the push as I must have 
# done something wrong with the symlinks.
# Some guy said it was possoble though - https://github.com/Sidnicious/gh-pages-symlink-test

#fdupes -r -1 . > ../dupes.txt
#while ((i++)); read -r line 
#do 
#    orig=$(echo "$line" | cut -d' ' -f1)
#    matches=$(echo "$line" | cut -d' ' -f2-9999 | tr ' ' '\n')
#    while read -r match 
#    do 
#        rm "${match}"
#        ln -s "$orig" "${match}"
#    done <<< "$matches"
#done < ../dupes.txt
cd ..


