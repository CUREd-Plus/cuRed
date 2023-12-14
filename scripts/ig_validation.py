real = """""".split("|")
dsa = """""".split()

print("Elements in common of the two lists")

for s in sorted(set(real) & set(dsa)):
    print(s)
  
print()
print("Elements in reference list that are not in the data received")

for s in sorted(set(dsa) - set(real)):
    print(s)

print()
print("Elements received that are not in the reference list")

for s in sorted(set(real) - set(dsa)):
    print(s)
