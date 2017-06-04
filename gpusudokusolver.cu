#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
int board[16][16] , lock[16][16];
__global__
void possible_move(int sqr , int row,int col ,int move ,int n,int *brd, int *flag){
int tid = threadIdx.x;
if(brd[row*n + tid]==move||brd[tid*n + col]==move||brd[((row/sqr)*sqr+tid/sqr)*n + (col/sqr)*sqr+tid%sqr]==move)
    *flag=1;
}
void print_board(int n){
  int i ,t1;
  for ( i = 0; i < n; i++) {
    for (t1  = 0; t1 < n; t1++) {
      printf("%d  ",board[i][t1]);
    }
    printf("\n");
  }
}
void solve(int n)
{
  int i, j ,k,sqr,*ibd,*flag,size,zero;
  size = sizeof(int);
  sqr=sqrt(n);
  zero=0;
  cudaMalloc(&ibd,size*n*n);
  cudaMalloc(&flag,size);
  for(i=0;i<n;i++){
    for(j=0;j<n;j++){
      if(board[i][j]==0){
        for(k=0;k<=n;k++){
        cudaMemcpy(flag,&zero,size,cudaMemcpyHostToDevice);
        for(int t=0; t<n; t++){
            cudaMemcpy(ibd+t*n,(int *)board[t],size*n,cudaMemcpyHostToDevice);
        }
        possible_move<<<1,n>>>(sqr,i,j,k,n,ibd,flag);
        cudaMemcpy(&zero,flag,size,cudaMemcpyDeviceToHost);
      if(zero==0)
            {board[i][j]=k;break;}
          else{
            if(k==n){
              if(i==0&&j==0)
                return;
              lock:;
              if(j==0){
                j=n;
                i--;
                if(lock[i][j]==1)
                  goto lock;
                k=board[i][j];
                board[i][j]=0;
              }
              else{
                j--;
                if(lock[i][j]==1)
                  goto lock;
                k=board[i][j];
                board[i][j]=0;
              }
              if(k==n){
                goto lock;
              }
            }
            zero=0;
          }
        }
      }
      printf("\nNextmove %d %d\n",i,j);
      print_board(n);
    }
  }
}
int main(){
  int n,**s,i,p,t1,t2,t3;
  float t4;
  printf("Enter Board Size:");
  while(1){
    scanf("%d",&n);
    t4 = sqrt(n);
    if(n==(int)t4*(int)t4)
      break;
    printf("Enter correct Boards size:");
  }
//Predefined board Numbers
  printf("Enter no. of Predefined numbers:");
  scanf("%d",&p );
  for(i=0;i<p;i++){
    scanf("%d%d%d",&t1,&t2,&t3);
    if(t1<=n&&t2<=n&&t3<=n&&t1>0&&t2>0&&t3>0){
      board[t1-1][t2-1]=t3;
      lock[t1-1][t2-1]=1;
    }
}

  //Print board
  printf("\nInitial Board\n");
  print_board(n);
  //solve board
  solve(n);
  printf("\nFinal Board\n");
  print_board(n);
  return 0;
}
