#include <iostream>
#include <vector>
#include <cstdlib>
#include <math.h>
#include <fstream>

using namespace std;

#define  BLOCK_SIZE     16
#define FIFO 1

unsigned long long mask[] = {0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

bool cache_check(vector< vector<unsigned long long > > &cache, int assoc, unsigned long long tag, int policy, unsigned long long index);

int main ( int argc, char *argv[]) {
    char *file;
    if (argc == 2) {
        file = argv[1];
    }
    else {
        cout << "Enter file name as command line argument\n";
        exit(0);
    }
	vector<unsigned long long > dataL;
	ifstream infile(file);
	unsigned long long address;
	while(infile >> hex >> address)
		dataL.push_back(address);
	infile.close();


	for(int policy(0); policy<2;policy++)
	{
		if(policy == FIFO)
			cout << "\n\n\t\tFIFO Replacement Policy\n\t1024\t2048\t4096\t8192\t16384";
		else
			cout << "\n\n\t\tLRU Replacement Policy\n\t1024\t2048\t4096\t8192\t16384";
		
		for(int j(0);j<4;j++){ //loop through associativity
			cout << "\n" << pow(2,j) << "\t";
			for(int k(0);k<5; k++)//loop through cache size
			{
				//CALCULATE VARIABLES
				int assoc(int(pow(2,j)));
				int cache_size(int(pow(2,10+k)));
				int blocks((cache_size/BLOCK_SIZE)/assoc);
				int index_size(int(log2(blocks)));
				int offset_size(int(log2(BLOCK_SIZE)));
				int index_mask(blocks-1);
				
				//BUILD CACHE
				vector< vector <unsigned long long > > cache(blocks,vector<unsigned long long> (assoc+1,0)) ;
				
				//READ MEMORY ACCESSES FROM FILE
				int total(0), miss(0);
				unsigned long long data,tag,index;
				for (vector<unsigned long long>::iterator it = dataL.begin() ; it != dataL.end(); ++it){
					tag = *it >> (index_size + offset_size);
					index = (*it >> offset_size) & index_mask;
				
					//CHECK CACHE & ADD ELEMENT
					if(cache_check(cache, assoc, tag, policy, index))
						miss++;
				}
				total = dataL.size();
				printf("%0.2lf\t", 100*(double)miss/ (double)total);
			}
		}
	}
	cout << endl;
	return 0;
}

bool cache_check(vector< vector<unsigned long long > > &cache, int assoc, unsigned long long tag, int policy, unsigned long long index){
	
	int match(-1);
	for(int i(0);i<assoc;i++){
		if(cache[index][i] == tag && (cache[index][assoc] & mask[i])){
			match = i;
			break;
		}
	}

	//cache hit
	if(match>-1){//place found vector back to the end & conserve valid bit vector
		if(policy != FIFO){//LRU
			unsigned long long temp = cache[index][assoc];
			cache[index].pop_back();
			cache[index].push_back(cache[index][match]);
			cache[index].erase(cache[index].begin()+match);
			cache[index].push_back(temp);			
		}
	}
	else{//add new element & conserve valid bit vector**cache[index][assoc]**
		unsigned long long temp = cache[index][assoc];
		cache[index].pop_back();
		cache[index].erase(cache[index].begin());
		cache[index].push_back(tag);
		cache[index].push_back(temp);
		
		//adjust the valid bit
		cache[index][assoc] = ((cache[index][assoc]>>1) | mask[assoc-1]);//adding to the mask
	}
	
	//return true if we have a cache miss
	return (match == -1)?1:0;
}
