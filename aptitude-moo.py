#!/usr/bin/python

import subprocess
from sys import argv

def moo(many_moos):
    command  = "aptitude"
    verbosity = '-'
    argument = "moo"
    for x in xrange(many_moos):
        verbosity = verbosity + 'v'
        subprocess.call([command, verbosity, argument])
        print '\n'

def main():

    # argv unpacks the parameters that you give it in the
    # terminal and saves it to an array. The if-else statement
    # allows the use to specify the number of times they want
    # to print -v or if they don't specify anything, just use
    # a single -v
    argv

    if len(argv) < 2:
        moo_num = 1
    else:
        moo_num = int(argv[1])

    moo(moo_num)


main()
