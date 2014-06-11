# -*- coding: utf-8 -*-
import sys
import os
import shutil
import time
import re

component_dir = None
component_name = sys.argv[1]
target_dir = None

def init_component_dir():
  global component_dir
  component_dir = os.path.abspath(__file__) \
                         .replace(__file__.replace('/', '\\'), '')[:-1]
  component_dir = os.path.sep.join([component_dir, 'src', 'components']) + os.path.sep

def remove_script():
  with open('index.html', 'r') as index:
    file_strs = index.readlines()

    for i, line in enumerate(file_strs):
      if re.match('\<!--components--\>', line):
        start_line = i + 1
      elif re.match('\<!--components end--\>', line):
        end_line = i - 2
        tpl = file_strs[i - 1].replace('<!--', '').replace('-->', '')

    to_remove = tpl.format(name=component_name)    

    for i, line in enumerate(file_strs[start_line:end_line + 1]):
      if re.match(to_remove, line):
        file_strs.pop(start_line + i)
        break

    index.close()    

  with open('index.html', 'w') as index:
    index.writelines(file_strs)
    index.close()


if __name__ == '__main__':
  init_component_dir()
  remove_script()
  shutil.rmtree(component_dir + '/' + component_name)
