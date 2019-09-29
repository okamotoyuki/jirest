# jirest

*jirest* is a command line tool to use Jira REST API easily and interactively from command line.

## Installation

On macOS,

1. Install [peco](https://github.com/peco/peco) and the dependencies.

    ```
    $ ./bin/setup
    ```

2.  Run the following command to setup your Jira Cloud Base URL, username (email address) and [API token](https://confluence.atlassian.com/cloud/api-tokens-938839638.html).

    ```
    $ bundle exec exe/jirest init
    ```

Also, if you use [docker](https://www.docker.com/), you don't need to install specific software and run the command on docker container.

1. Create *jirest* data directory under your `$HOME`.

    ```
    $ mkdir $HOME/.jirest
    ```
2. Now, you can use *jirest* with the following command.

    ```
    $ docker run -it --rm -v $HOME/.jirest:/root/jirest/data okamotoyuki/jirest
    ```
    
    We recommend you to add the following line to your `.bashrc`.
    
    ```
    alias jirest='docker run -it --rm -v $HOME/.jirest:/root/jirest/data okamotoyuki/jirest'
    ```
3. Run `jirest init` command to setup your Jira Cloud Base URL, username (email address) and [API token](https://confluence.atlassian.com/cloud/api-tokens-938839638.html).

    ```
    $ jirest init
    ```

## Usage

[jirest](https://github.com/okamotoyuki/jirest/blob/master/jirest.gif?raw=true)

- Initialize jirest config.

    ```
    $ jirest init
    ```

- Show information of a Jira REST API.

    ```
    $ jirest describe
    ```
    
- Generate a curl command to use a Jira REST API.

    ```
    $ jirest dryrun
    ```
    
- Edit a request template for a Jira REST API.

    ```
    $ jirest edit
    ```
    
- Execute a curl command to use a Jira REST API.

    ```
    $ jirest exec
    ```
    
- Describe available commands or one specific command.

    ```
    $ jirest help [COMMAND]
    ```

- Update all API definitions

    ```
    $ jirest update
    ```

- Revert all API definitions back to the stable version.

    ```
    $ jirest revert
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okamotoyuki/jirest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the jirest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/okamotoyuki/jirest/blob/master/CODE_OF_CONDUCT.md).
