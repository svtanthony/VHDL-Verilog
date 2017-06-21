#! /usr/bin/python

import sys
import math

BLOCK_SIZE = 16

def cache_check(cache, assoc, tag, policy, index):
    match = -1
    #search cache @ index through assoc
    if cache[index] != None:
        for i, x in enumerate(cache[index]):
            if (x == tag):
                match = i
    #if match > -1 and sizeof(cache[index]) < assoc-1
    if(match+1):
        if(policy == 0):
            #LRU - remove match and place @ back
            cache[index].append(cache[index].pop(match))
    else:
        #adjust size if needed 
        if(cache[index] != None):
            if(len(cache[index]) >= assoc):
                cache[index].pop(0)
        else:
            cache[index]= []
        cache[index].append(tag)
    return 0 if (match+1) else 1


def load_file(fileName):
    f = open(fileName, 'r')
    inFile = f.readlines()
    f.close()
    hexL = []
    for i in inFile:
        hexL.append(int(i,16))
    return hexL

def main():
    dataL = load_file(sys.argv[1])
    # Loop through policy
    for policy in range(0,2):
        if(policy):
            print "\n\n\t\tFIFO Replacement Policy\n\t1024\t2048\t4096\t8192\t16384",
        else:
            print "\n\n\t\tLRU Replacement Policy\n\t1024\t2048\t4096\t8192\t16384",
        # Loop through associativity
        for j in range(0,4):
            assoc = 2**j
            print "\n%i\t" % assoc,
            # Loop thriough cache sizes
            for k in range(0,5):
                cache_size = 2**(10+k)
                blocks = ((cache_size/BLOCK_SIZE)/assoc)
                index_size = math.log(blocks,2)
                offset_size = math.log(BLOCK_SIZE,2)
                index_mask = (blocks-1)

                cache = [None] * blocks

                total = len(dataL)
                miss = 0

                # iteratelist into function
                for y, address in enumerate(dataL):
                    tag = (address >> int(index_size+offset_size))
                    index = ((address >> int(offset_size)) & index_mask)
                    #if y % 100000 == 0:
                       # print "\n\naddress: %i, tag: %i, index: %i" % (address, tag, index)
                       # print "IM: %i, IS: %i, OS: %i, blocks: %i, cacheSize: %i\n" %(index_mask,index_size,offset_size,blocks, cache_size)
                    if(cache_check(cache,assoc,tag,policy,index)):
                        miss += 1
                print "%.2f\t" %((100*miss)/float(total)),
                #print "miss = %i and total = %i" % (miss, total),

main()
print
