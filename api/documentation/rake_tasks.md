# Endpoints

## Introduction
This project is a standard rails project. Therefore, you can get a good overview of all the rake tasks by checking the [`lib/tasks/`](../lib/tasks) directory. You can learn about rake tasks in rails here: https://guides.rubyonrails.org/v4.2/command_line.html#rake

## Repositories
The `lib/tasks/repositories.rake` contains a bunch of utility tasks related to repositories.

### Benchmark repository synchronization
The `repositories:benchmark_sync` task can be used to benchmark how long it takes to index a repository.

Example:
```
REPOSITORY_ID=1 bin/rake repositories:benchmark_sync
```

This will benchmark the full process of:
1. cloning the repository identified by id `1`
2. generating a log file of all the changes on that repo
3. indexing that log file into our database.
