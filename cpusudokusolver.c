#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
int board[16][16] , lock[16][16];
int possible_move(int row , int col , int move ,int n){
  int i , j, sqr;
  //column check
  for(i=0;i<n;i++){
    if(move == board[i][col])
      return -1;
  }
  //row check
  for(j=0;j<n;j++){
    if(move == board[row][j])
      return -1;
  }
  //square check
  sqr = sqrt(n);
  for(i = row/sqr*sqr ; i < (row/sqr+1)*sqr ; i++ ){
    for(j = col/sqr*sqr ; j < (col/sqr+1)*sqr ; j++ ){
      if(board[i][j]==move)
        return -1;
    }
  }
  return 0;
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
  int i, j ,k,r;
  for(i=0;i<n;i++){
    for(j=0;j<n;j++){
      if(board[i][j]==0){
        for(k=0;k<=n;k++){
          if(possible_move(i,j,k,n)==0)
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
          }
        }
      }
      //Comment to disable per move information.
      //printf("\nNextmove %d %d\n",i,j);
      //print_board(n);
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
    printf("Enter X Y Number %d :",i+1);
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
