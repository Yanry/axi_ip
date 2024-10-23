import random

random_list = []

n = 8
for i in range(0, n):
    random_num = random.random()
    random_int = int(random_num * (8 ** 8))
    random_hex = hex(random_int)[2:]
    random_list.append(random_hex)

with open ('./mem1.txt', 'w') as fp:
    [fp.write(str(item)+'\n') for  item in random_list]
    fp.close
