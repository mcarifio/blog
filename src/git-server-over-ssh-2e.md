---
Author: Mike Carifio &lt;<mike@carif.io>&gt;\
Title: Making Remote Git Repositories Is Still Too Complicated\
Date: 2019-03-12\
Tags: #git, #ssh, #ssh_config, #git_server\
Blog: [https://mike.carif.io/blog/git-server-over-ssh-2e.html](https://mike.carif.io/blog/git-server-over-ssh-2e.html)\
VCS: [https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/git-server-over-ssh-2e.md](https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/src/git-server-over-ssh-2e.md)
---

# Making Remote Git Repositories Is Still Too Complicated

## TL;DR

Annoyed by the ballet needed to create a remote git repository, I wrote three bash scripts that make it as easy to create remote repositories as it is to create local ones: 
`git initclone ${name}`, `git initpush ${name}` and (behind the scenes) `mkrepo.sh`. The scripts embed a lot of assumptions. They don't (yet) generalize. But its a good start.

At the bottom I bloviate about complexity in software (bad), orchestrating services (challenging, necessary) and code deployment (copying) 
as an obstacle to making good abstractions in distrubted systems (challenging, necessary). Nothing you haven't read before, but I feel so important
writing it.

## Introduction

I recently wrote a [longish blog entry](./git-server-over-ssh.html) about setting up a small (set of) git repositories using ssh public key, password-less authenication. You
can find several of these on the interwebs including a [fairly terse one](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server) in the official git online book.
I disliked that treatment because it offered no way to debug or help yourself if the commands don't work. Basically only the happy path is covered ... quickly. 
Yet errors happen. So I did a more tutorial presentation (hope you liked it) that also included the thought process on what you were doing and why. And if things went bad, what you might check and how. A little more leisurely, a little more current, a little more conversational. Of course, like all posts, it will age. They never age well either.

Nevertheless, setting up a remote repo is too complicated. Too many steps. Too much coordination between the local clone and the remote `origin`. It should take one command, similar to either `git init .` or `git clone ${url}`. So based on the work from the previous blog entry, I turned it into a single command: either `git initclone ${url}` or `git initpush ${name}`. Details below.

## Background

What is a "remote repository"? Well. It's remote (on a different computer) and a git repository. 
Let's do the git repository part first below. I'll create a simple git repository 
`/tmp/lgit0` and then clone it into `/tmp/lgit1'.

```bash
# Allow easier cut-and-paste of bash commands
$ p=''; PS1="$PS1 \$p " 

# Create a working directory in /tmp/lgit0
$p mkdir /tmp/lgit0; cd $_
$p git init .
Initialized empty Git repository in /tmp/lgit0/.git/

# Populate lgit0 with a file pwd.txt.
$p pwd > pwd.txt ; git add pwd.txt; git commit -m 'pwd.txt' pwd.txt
[master (root-commit) 54cd3fc] pwd.txt
 1 file changed, 1 insertion(+)
 create mode 100644 pwd.txt

# Clone lgit0 into lgit1
$p cd ..
$p git clone lgit0 lgit1
Cloning into 'lgit1'...
done.


# lgit0 is lgit1's "origin"
$p cd lgit1
$p git remote -v 
origin	/tmp/lgit0 (fetch)
origin	/tmp/lgit0 (push)

# Add to lgit0's pwd.txt and commit it in lgit0.
$p pwd >> ../lgit0/pwd.txt 
$p cat ../lgit0/pwd.txt
/tmp/lgit0
/tmp/lgit1
$p (cd ../lgit0; git add pwd.txt ; git commit -m 'lgit1')
[master dde603a] lgit1
 1 file changed, 1 insertion(+)


# Nothing's changed in lgit1 yet.
$p cat pwd.txt
/tmp/lgit0

# Pull origin's changes.
$p git pull
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /tmp/lgit0
   54cd3fc..dde603a  master     -> origin/master
Updating 54cd3fc..dde603a
Fast-forward
 pwd.txt | 1 +
 1 file changed, 1 insertion(+)

# See the changes.
$p cat pwd.txt
/tmp/lgit0
/tmp/lgit1
```

Note that:

- `/tmp/lgit0` and `/tmp/lgit1` are both git repositories. They have a `.git` subdirectory that stores versions (git calls them "trees of blobs").

- `lgit1` has an `origin` relationship with `lgit0`, set up via a `git clone`. The relationship isn't magic. 
  `origin` is generally used as the default repository for `pull`, `fetch` and `push` commands. 

- `lgit1` isn't remote. It's on the same machine. But it could be remote, as we'll see below.

- You can have more than one remote. You could create the remote `upstream`, for a git repository you consider "upstream" of your code. 
  You can also name repositories after work colleagues, e.g.: 

```bash
# Create a new remote named `mike@carif.io`
$p git remote add mike@carif.io /tmp/lgit2

# Create its associated git repo. Note that we created the name before the repo.
$p git init --bare /tmp/lgit2
Initialized empty Git repository in /tmp/lgit2/

# Push the master branch to a named repo.
$p git push mike@carif.io master
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (6/6), 432 bytes | 432.00 KiB/s, done.
Total 6 (delta 0), reused 0 (delta 0)
To /tmp/lgit2
 * [new branch]      master -> master

# Look inside the repo, it has contents.
$p tree -C /tmp/lgit2
/tmp/lgit2
├── branches
├── config
├── description
├── HEAD
├── hooks
│   ├── applypatch-msg.sample
... output removed ...


# Look at the remote's (local copy of the) log of commits.
$p git -P log mike@carif.io/master 
commit dde603a883613e4f1f9248d0f022cd3238a331e3 (HEAD -> master, origin/master, origin/HEAD, mike@carif.io/master)
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:17:22 2019 -0400

    lgit1

commit 54cd3fc8609835ac530f4ddc9825ea4d95d9f979
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:14:56 2019 -0400

    pwd.txt


# Compare that with "remote" directly. They're the same.
$p git -P --git-dir=/tmp/lgit2 log -n2
commit dde603a883613e4f1f9248d0f022cd3238a331e3 (HEAD -> master)
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:17:22 2019 -0400

    lgit1

commit 54cd3fc8609835ac530f4ddc9825ea4d95d9f979
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:14:56 2019 -0400

    pwd.txt
```

We're almost home. Note that in the example above, for the remote named `mike@carif.io`, we created the remote name, _then_ the associated git repository. Adding a remote just creates a name for a url, nothing more. Also note that `git push` pushed to an existing (created) repository. Push itself has no way of creating repositories during the push. But you can make it seem that way by creating the remote "just in time" with a script during a "specialized push". Or clone. Let's push `/tmp/lgit0` to a different machine using ssh manually. I'll run through it pretty quickly, you saw this in excrutiating detail in [the previous post](./git-server-over-ssh.html).

```bash
# Create an empty "bare" directory at git.carif.io
$p ssh git@git.carif.io git init --bare repos/lgit0.git
Initialized empty Git repository in /home/git/repos/lgit0.git/

# Make `git@git.carif.io:repos/lgit0.git` the origin for /tmp/lgit0, after the fact.
$p git remote add origin git@git.carif.io:repos/lgit0.git

# Push the master branch to (the new) origin
$p git push -u origin master
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (6/6), 432 bytes | 432.00 KiB/s, done.
Total 6 (delta 0), reused 0 (delta 0)
To git.carif.io:repos/lgit0.git
 * [new branch]      master -> master

# Trying cloning from git@git.carif.io:repos/lgit0.git
$p cd /tmp
$p git clone git@git.carif.io:repos/lgit0.git from-remote
Cloning into 'from-remote'...
remote: Counting objects: 6, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 6 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (6/6), done.

# Look around
$p cd from-remote/
$p git remote -v
origin	git@git.carif.io:repos/lgit0.git (fetch)
origin	git@git.carif.io:repos/lgit0.git (push)
$p git -P log -n2
commit dde603a883613e4f1f9248d0f022cd3238a331e3 (HEAD -> master, origin/master, origin/HEAD)
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:17:22 2019 -0400

    lgit1

commit 54cd3fc8609835ac530f4ddc9825ea4d95d9f979
Author: Mike Carifio <mike@carif.io>
Date:   Wed Mar 13 16:14:56 2019 -0400

    pwd.txt
$p 

```

## Interlude 0

So far:

- You've learned about git remotes. You've experimented with a few.

- You know how to configure ssh to run commands remotely without passwords. Snuck that one in, it was in the [previous blog post](./git-server-over-ssh.html).

- You can `clone`, `pull` and `push` with the best of 'em.

- You know the difference between normal and ["bare" git repos](https://mijingo.com/blog/what-is-a-bare-git-repository). Another "sneak in", you don't, at least not from me. A bare git repository has no "working tree". That's all the stuff you're working on and is everything _outside_ the `.git` folder. You bare your soul with the `--bare` switch.

Whew! Lotta backstory for a few simple scripts. But they'll make more sense now.


## Git "Subcommand"

As you know, git commands are prefixed with the `git` command itself, i.e. `git log` or `git commit`. What you might not know is that `git ${command}` is actually implemented with `git-${command}` somewhere along PATH. For example, `git log` is implemented by `/usr/lib/git-core/git-log`. This isn't just for "pre-defined" commands, you can add your own. We're about to add a few now.








