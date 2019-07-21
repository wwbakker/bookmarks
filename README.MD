# Bookmarks application
An application which can be used as a start page in your browser to quickly
navigate to often used websites or applications. Especially useful for people
working in large organizations with many internal websites, applications and environments.

## Prerequisites
This project is made with elm 0.19.

## Configuring your websites
Add your bookmarks inside `src/PrivateBookmarks.elm`.

## Building the application
```
PS E:\dev\Repos\bookmarks> elm make src/Main.elm
Success! Compiled 1 module.
```
Now the application is built as `index.html`. 

## Developing the application
Currently this application is runnable by going to the base directory and running elm reactor.
```
PS E:\dev\Repos\bookmarks> elm reactor
Go to <http://localhost:8000> to see your project dashboard.
```
Now you can run it by going to:
`http://localhost:8000/src/Main.elm`