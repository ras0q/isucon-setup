# isucon-setup

## Usage

Add deploy key to your GitHub repository.

```sh
ssh-keygen -q -t ed25519 -C '' -N '' -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
# open <repo url>/settings/keys and add deploy key
```

Clone this repository and run `make` command.

```sh
git clone git@github.com:ras0q/isucon-setup.git /tmp/isucon-setup
cd /tmp/isucon-setup
make
```

## Utilitiy commands

See [./bin/](./bin/)
