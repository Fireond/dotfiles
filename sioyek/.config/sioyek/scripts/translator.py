import sys
from googletrans import Translator
import subprocess

if __name__ == '__main__':
    sioyek_path = sys.argv[1]
    text = sys.argv[2]
    translator = Translator()
    translation = translator.translate(text, dest='en')
    subprocess.run([sioyek_path, '--execute-command',
                   'set_status_string', '--execute-command-data', translation.text])
