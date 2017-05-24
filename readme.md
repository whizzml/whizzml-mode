[![MELPA](https://melpa.org/packages/whizzml-mode-badge.svg)](https://melpa.org/#/whizzml-mode)

# WhizzML mode for Emacs

This package provides a major mode for editing WhizzML source code.
WhizzML is BigML's DSL for Machine Learning workflows and algorithms.
See https://bigml.com/whizzml for details.

## Installation

### Manual

- Add this repo's checkout directory to your load path
- `(require 'whizzml-mode)`

### Using MELPA

Add MELPA to your package sources and then `M-x package-install RET
whizzml-mode` should do the trick.

## Features

- Syntax highlighting (font lock)
- Completion (via `M-x` and also company-mode) for all WhizzML
  built-ins and standard functions
