import sys
import subprocess

if __name__ == '__main__':
    text = sys.argv[1]
    subprocess.run(['echo', text])
