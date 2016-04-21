#!/usr/bin/env python
'''
convert vimscript in a particular format to Markdown.

Conventions:

- `" `: a paragraph line, or text, or whatever. It's not transformed aside from
  removing the leading `"`.
- a bunch only `"`s on a line, followed by a `""" HEADING """`, followed by
  more `"`s on the next line: section heading (h2)
- `"""`: a subhead (h3)
- anything else: code (indented four places)

Blank lines are preserved.
'''
from __future__ import print_function
import sys


def wrapcode(lines):
    return ['', '```vim'] + lines + ['```', '']


def convert(lines):
    out = []
    code = []

    for line in lines:
        line = line.rstrip()

        if line == '':
            if code:
                code.append(line)
                continue
            else:
                line = line # no transformation, preserving blank lines
        elif line.strip('"') == '':
            continue
        elif line.startswith('""" ') and line.endswith(' """'):
            line = '## ' + line[4:-4]
        elif line.startswith('""" '):
            line = '### ' + line[4:]
        elif line.startswith('" '):
            line = line[2:]
        else:
            code.append(line)
            continue

        if code:
            out.extend(wrapcode(code))
            code = []

        out.append(line)

    if code:
        out.extend(wrapcode(code))

    return out


def main():
    raw = sys.stdin.readlines()
    converted = convert(raw)
    print('\n'.join(converted))

if __name__ == '__main__':
    main()
