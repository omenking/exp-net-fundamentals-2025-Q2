## How to Deploy

### Check Your AWS Account

```sh
aws sts get-caller-identity
```

### Run Deploy Script
```sh
cd projects/env_automation
chmod u+x ./bin/deploy
./bin/deploy
```

> you only have to chmod the file once to make it executable.