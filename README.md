Download JIRA project to static site suitable for Github Pages deplyment. Bye bye Codehaus - it was fun.

# Setup.

All this on the Mac.


1. Get the Java Jars for Sikulix 

    Go read http://paulhammant.com/2015/02/21/playing-with-sikuli-for-desktop-automation/ and do the git clone, and 'mvn install' for that. It'll bring down many Jars from Maven for you. Then set an export:

    ``` bash
    export SIKULIXAPI_JAR=~/.m2/repository/com/sikulix/sikulixapi/1.1.0-SNAPSHOT/sikulixapi-1.1.0-SNAPSHOT.jar
    ```

2. Install JRuby

    ```
    brew install jruby
    ```

3. Install the Gem that's in the repo

    ``` bash
    jruby -S gem install sikulix-1.1.0.3.gem
    ```

4. Make a repo

    Don't make a README

    Make it a Github-pages site to it - see in the settings for the project - follow the wizard for automatic site creation.

    Make sure to note the repository's name. 

5. Clone / purge the default content / push that back

    Clone it, and make sure to delete all the default content that Github makes for you, and push it back, after you've run through the wizard. It is a shame you HAVE to choose a theme in Github-Pages - I'd like a "no theme".

    Commit and push it back to the gh-pages branch

6. Install the MAFF plugin into Firefox.

    [https://addons.mozilla.org/en-us/firefox/addon/mozilla-archive-format/](https://addons.mozilla.org/en-us/firefox/addon/mozilla-archive-format/)

7. Work out the highest bug number for your JIRA project.

8. Launch Firefox

    Click somewhere within it to take away that blue effect on the URL field.

9. Run the script

    Note - this is the first time you'll need to have cloned this repo.

    ```
    ./exportJira.sh THE_NEW_GH_REPO_NAME YOUR_JIRA_PROJECT_CODE HIGHEST_ISSUE_NUM
    ```

    e.g.

    ```
    ./exportJira.sh Old_XStream_Issues XSTR 769
    ```

    Take your hands off the computer while this is running. After Firefox stops changing, there's still a few minutes left. Yes it's slow.

10. cd into work and do a 'git init'

11.  Add the remote for the github pages repo.

    Make sure and switch to the gh-pages branch

    Add all the content, commit and push. You might have had to pull first, of course.

12. Enjoy your site. 

    It'll be on something like http://YOUR_GH_NAME.github.io/THE_NEW_GH_REPO_NAME/