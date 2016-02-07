<img src="https://github.com/veelenga/ss/blob/master/vicr/logo.png" width="200">

[![Build Status](https://travis-ci.org/veelenga/vicr.svg?branch=master)](https://travis-ci.org/veelenga/vicr)

Vicr stands for **"Vim-like Interactive CRystal"** and represents a tiny command line application
that designed to quickly execute Crystal code with fast feedback and options to proceed:

![](https://media.githubusercontent.com/media/veelenga/ss/master/vicr/demo.gif)

## Installation

### OS X

```sh
$ brew tap veelenga/tap
$ brew install vicr
```

### From sources:

```sh
$ git clone https://github.com/veelenga/vicr
$ cd vicr
$ make
$ sudo make install
```

## Usage

Open terminal, run `vicr`, write your Crystal program, save and exit.

### Options

Vicr is able to load file content for you to start playing with Crystal code straight away.
For example:

```sh
# loads local file
$ vicr src/vicr/cli.cr

# loads Github file
$ vicr https://github.com/manastech/crystal/blob/master/samples/2048.cr

# loads Github gist
$ vicr https://gist.github.com/veelenga/a5b861ccd32ff559b7d2#file-benchmark_test-cr

# loads CarcIn file
$ vicr https://carc.in/#/r/rlj

# loads raw file
$ vicr http://example.com/program.cr
```

Use help (`-h` flag) for more information.

### Customization

It is possible to configure Vicr start-up settings using `~/.vicr/init.yaml` configuration file.
File with default config is created on a first run. You can customize it and use your favorite editor with required settings.

```yml
# ~/.vicr/init.yaml
---
run_file: ~/.vicr/run.cr
editor:
  executable: nvim
  args:
    - "--cmd"
    - "set paste"
```

## Contributing

If you feel like you have a good idea to be implemented, please open a discussion.
If you found a defect and enough motivated to fix it, pull requests are welcome.
