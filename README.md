# DevOps

DevOps is a methodology in the software development and IT industry. 

Used as a set of practices and tools, DevOps integrates and automates the work of software development (Dev) and IT operations (Ops).

Here you will find some tools and configuration examples for setting up a devops environment.

The examples refer to the `wdemo` project present in the repository `https://github.com/giosil/multi-rpc`.

## Usual procedure for release

Suppose we start from this situation:

- `git branch`

```
  collaudo
  master
  produzione
* sviluppo
```

Proceed with the merges on the other branches:

- `git checkout master`
- `git merge sviluppo`
- `git commit -m "update"`
- `git push --set-upstream origin master`

- `git checkout collaudo`
- `git merge sviluppo`
- `git commit -m "update"`
- `git push --set-upstream origin collaudo`

Return to the development branch:

- `git checkout sviluppo`

Proceed with the creation of the merge request `collaudo` -> `produzione`.

## Contributors

* [Giorgio Silvestris](https://github.com/giosil)