import sys
from os import path, getcwd

def median(L):
  L.sort()
  if len(L) % 2 == 0 :
    v1 = L[len(L)//2]
    v2 = L[(len(L)//2) - 1]
    return (v1 + v2) / 2
  else:
    return L[(len(L) - 1)//2]

def main(filename,label):
  total_time = 0.0
  times = []
  count = 0

  # Get the input
  stat_file = path.join(getcwd(), filename)
  with open(stat_file) as f:
    for line in f:
      times.append(float(line.strip()))
      total_time += times[-1]
      count += 1

  # Find the stats
  med = median(times)
  mean =  total_time / count

  # produce the output
  with open("stats.txt", "a+") as out:
    out.write("\n")
    out.write(label + "\n")
    out.write("Mean: "+str(mean) + "\n")
    out.write("Median: "+str(med) + "\n")
    out.write("\n")





if __name__ == "__main__":
  if len(sys.argv) != 3:
    print("Usage: python3 stats.py <filename> <output label>")
  else:
    main(sys.argv[1],sys.argv[2])
