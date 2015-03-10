Download JIRA project to static site suitable for Github Pages deplyment. Bye bye Codehaus - it was fun.

# Setup.

All this on the Mac.

1. Do and export for env var 'SIKULIXAPI_JAR'

You may have to go get sikulixapi-1.1.0-SNAPSHOT.jar from https://oss.sonatype.org/service/local/repositories/snapshots/content/com/sikulix/sikulixapi/1.1.0-SNAPSHOT/sikulixapi-1.1.0-20150116.001551-75.jar

I found it in my local Maven repo:

``` bash
export SIKULIXAPI_JAR=/Users/YOUR_MAC_USER_NAME/.m2/repository/com/sikulix/sikulixapi/1.1.0-SNAPSHOT/sikulixapi-1.1.0-SNAPSHOT.jar
```

2. Install JRuby

```
brew install jruby
```

3. Install the Gem that's in the repo

``` bash
gem install sikulix-1.1.0.3.gem
```

4. Make a repo

And note it's name. 

Make a Github-pages site to it (see in the settings for the project)
Make sure to delete all the content and push it back, after you've run through the wizard. Shame you HAVE to choose a template.

5. commit and push it back to the gh-pages branch

6. Install the MAFF plugin into Firefox.

[https://addons.mozilla.org/en-us/firefox/addon/mozilla-archive-format/](https://addons.mozilla.org/en-us/firefox/addon/mozilla-archive-format/)

7. Work out the highest bug number for your JIRA project.

8. Launch Firefox

Click somewhere within it to take away that blue effect on the URL field.

9. Run the script

```
./exportJira.sh THE_NEW_GH_REPO_NAME OUR_JIRA_PROJECT_CODE HIGHEST_ISSUE_NUM
```

Take your hands off the computer.

10. cd into work and do a 'git init'

11.  Add the remote for the github pages repo.

Make sure and switch to the gh-pages branch

Add all the content, commit and push. 

12. Enjoy your site. 

It'll be on something like http://YOUR_GH_NAME.github.io/THE_NEW_GH_REPO_NAME/