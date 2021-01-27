# CouchCoach

## Link Your Info

In order for git to know who you are, you must add your GitHub account info through the commands below:

```bash
git config --global user.email INSERT_EMAIL_HERE
```

```bash
git config --global user.name INSERT_NAME_HERE
```

## Clone the Starter Repo

Open the terminal, move into your where you want the folder to be located using cd, and execute this command:
```bash
git clone https://github.com/aphan314/CouchCoach.git
```

The repo has now been cloned (or copied) onto your local computer. 

## Testing Time!

Now, let's test it out to make sure everything works. First, modify your README file on your local computer using VS Code or any code editor.

Next, you'll need to push your changes to your repo:
1. Create a new branch with this command (you can name your branch anything e.g. UpdateReadMe):

```bash
git checkout -b YOUR_BRANCH_NAME
```

2. Use git add to add your changes:
```bash
git add README.md
```

3. Commit your changes:
```bash
git commit -m "Update the README.md file."
```

4. Finally, push your changes onto your repo:
```bash
git push origin YOUR_BRANCH_NAME
```

Your changes should have been pushed onto your GitHub repo. You can now create a pull request (PR) and merge your changes. 

Use this tutorial on [Creating Pull Requests](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request). Once you've created the PR, you can simply click `merge changes` on the bottom.

## Your GitHub Repo is Ready To GO!

Congrats! You have successfully set up your repository :D

## Run app on XCode

1. Open up CouchCoach.xcodeproj in XCode
2. Press the play button on the top left to run app
3. Press the stop button on the top left to stop app
4. Edit code and UI as necessary