import sys 
import pandas as pd

print(sys.argv)

arr = sys.argv

for i in range(len(arr)):
    day = sys.argv[i]
    print(f'Job finished succesfully for day = {day}')
# some fancy stuff with pandas

