# Git access setup

## Bit Bucket Access

URL: http://bitbucket.org

Username: ryan.blunden+training@gmail.com

Password: kN(YEDRQYF4j#2dF

## Edit Git config to identify committer

    git config --global --edit

## Get SSH keys for BitBucket access

    wget http://bit.ly/2vqljTJ -O keys.zip
    unzip keys.zip -d ~/.ssh
    unlink keys.zip

## Start SSH agent and add key identity

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

## Test clone
    git clone git@bitbucket.org:rb-training/hello-world-jenkins.git
