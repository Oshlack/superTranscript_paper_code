/**
 ** This command will convert a blat .psl file into a .chain file for use with UCSC's liftOver
 ** program. It was written to transform superTranscript coordinates into genomic coordinates.
 **
 ** Example of use:
 ** Run blat, "blat genome.fasta superTranscript.fasta -minScore=200 -minIdentity=98 mapping.psl"
 ** Run this program, "psl2chain mapping.psl > mapping.chain"
 ** Run liftOver, "liftOver superTranscriptSNPs.bed mapping.chain genomeSNPs.bed unMapped.bed"
 ** 
 ** Author: Nadia Davidson, nadia.davidson@mcri.edu.au
 ** Modified: 20 March 2017
 **/ 

#include <iostream>
#include <fstream>
#include <istream>
#include <string>
#include <sstream>
#include <map>
#include <stdlib.h>
#include <vector>
#include <algorithm>

using namespace std;

/**
 * Take a psl file from blat and report the chain * 
 **/
vector<int> get_vector_from_list(string comm_list){
  vector<int> result;
  istringstream string_stream(comm_list);
  string pos;
  while(getline(string_stream,pos,',')){
    result.push_back(atoi(pos.c_str()));
  };
  return result;
};

// the real stuff starts here.
int main(int argc, char **argv){
  if(argc!=2){
    cout << "Wrong number of arguments" << endl;
    cout << endl;
    cout << "Usage: psl2chain <psl>" << endl;
    exit(1);
  }
  int id=1;

  ifstream file;
  //Open the exons file
  file.open(argv[1]);
  if(!(file.good())){
    cout << "Unable to open file " << argv[1] << endl;
    exit(1);
  }
  // reading the blat table
  string line, column;
  string chrom_id, trans_id, strand;
  int trans_size, trans_start, trans_end;
  int chrom_size, chrom_start, chrom_end;
  for(int line_skip=5; line_skip!=0 && getline(file,line) ; line_skip--); //skip the header lines
  while(getline(file,line) ){
    istringstream line_stream(line);
    //skip the first 8 columns (we are only interested in block positions)
    for(int col_skip=8; col_skip!=0 && (line_stream >> column); col_skip--);
    line_stream >> strand;
    line_stream >> trans_id;
    line_stream >> trans_size;
    line_stream >> trans_start;
    line_stream >> trans_end;
    line_stream >> chrom_id;
    line_stream >> chrom_size;
    line_stream >> chrom_start;
    line_stream >> chrom_end;
    for(int col_skip=1; col_skip!=0 && (line_stream >> column); col_skip--);
    line_stream >> column;
    vector<int> junc_size = get_vector_from_list(column);
    line_stream >> column;
    vector<int> trans_junc_start = get_vector_from_list(column);
    line_stream >> column;
    vector<int> chrom_junc_start = get_vector_from_list(column);
    vector<int> block_width=junc_size;
    vector<int> trans_gap, chrom_gap;
    for(int i=0 ; i <junc_size.size()-1 ; i++){ //get the spacing between ungapped blocks
      trans_gap.push_back(trans_junc_start.at(i+1)-trans_junc_start.at(i)-junc_size.at(i));
      chrom_gap.push_back(chrom_junc_start.at(i+1)-chrom_junc_start.at(i)-junc_size.at(i));
    }
    if(strand=="-"){ //do some magic to make reverse compliments work
      reverse(block_width.begin(),block_width.end());
      reverse(trans_gap.begin(),trans_gap.end());
      reverse(chrom_gap.begin(),chrom_gap.end());
      int temp=chrom_start;
      chrom_start=chrom_size-chrom_end;
      chrom_end=chrom_size-temp;
    }
    cout << "chain\t1\t" //output the chain line
	 << trans_id << "\t" << trans_size << "\t+\t"<< trans_start<<"\t" << trans_end << "\t" 
	 << chrom_id << "\t" << chrom_size << "\t" << strand << "\t" << chrom_start << "\t" << chrom_end << "\t"
	 << id << endl;
    for(int i=0 ; i <junc_size.size()-1 ; i++){ //output the block alignments
      cout << block_width.at(i) << "\t"
	   << trans_gap.at(i) << "\t"
	   << chrom_gap.at(i) << "\t"
	   << endl;
    }
    cout << block_width.at(block_width.size()-1) << endl;;
    id++;
  }
  file.close(); //done
}

