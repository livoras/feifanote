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

def make_component():
  fixtures_dir = os.path.dirname(__file__) + '/fixtures'
  target_dir = make_target_dir()

  for root, dirs, files in os.walk(fixtures_dir):
    target_root = target_dir + root.replace(fixtures_dir, '')

    for dir_name in dirs:
      os.mkdir(os.path.sep.join([target_root, dir_name.format(name=component_name)]))

    for file_name in files:  
      target_file = os.path.sep.join([target_root, file_name.format(name=component_name)])
      print target_file + ' ======> created!'
      with open(target_file, 'w') as f:
        with open(os.path.sep.join([root, file_name]), 'r') as t:
          tpl = t.read()
          f.write(tpl.format(name=component_name, initial_style='{\n\n}'))
          t.close()
          f.close()

def make_target_dir():
  global target_dir
  target_dir = component_dir + component_name
  try:
    os.mkdir(target_dir)
  except BaseException, e:  
    print 'Error: ==> %s component has already existed.' % component_name 
    exit()
  return target_dir  

def append_script():
  with open('index.html', 'r') as index:
    file_strs = index.readlines()
    for i, line in enumerate(file_strs):
      if re.match('\<!--components end--\>', line):
        tpl = file_strs[i - 1].replace('<!--', '').replace('-->', '')
        file_strs.insert(i - 1, tpl.format(name=component_name))
        print 'index.html script ======> wrote'
        break
    index.close()    

  with open('index.html', 'w') as index:
    index.writelines(file_strs)    
    index.close()

if __name__ == '__main__':
  init_component_dir()
  make_component()
  append_script()
  # time.sleep(3)
  # shutil.rmtree(target_dir)
