/*        Ben Gonner
        bjgonner@iastate.edu 
        CPRE 185 Section W  
Programming Practice NUMBER 1
         <Reflection 1 What were you trying to learn or achieve?>
                Answer here (A few sentences is sufficient.)
        <Reflection 2 Were you successful? Why or Why not?>
        Answer here (a few sentences is sufficient.)
<Reflection 3 Would you do anything differently if starting this program over?  If so, explain what.>
        Answer here (a few sentences is sufficient.)
<Reflection 4 Think about the most important thing you learned when writing this piece of code.  What was it and explain why it was significant.>
        Answer here (a few sentences is sufficient.)
<Other questions/comments for Instructors>
        Answer here (optional)
*/

#include <stdio.h>
#define NUM_ROWS 8
#define NUM_COLUMNS 16
#define DRAW_BOARD for(k=0;k<NUM_ROWS;k++){printf("%s\n",board[k]);}

void OPlayerTurn(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE);//prints the board, lets P1 pick a row to drop a piece, updates the board.
void XPlayerTurn(char board[][NUM_COLUMNS], char PLAYER_TWO_PIECE);//prints the board, lets P2 pick a row to drop a piece, updates the board.
int winnerVertical(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner); //Checks all columns to see if there is a vertical win.
int winnerHorizontal(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner); //Checks all the rows to see if there is a horizontal win.
int winnerDiagnal(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner); //Checks each column starting at the top, reading diagonal
																										//down and to the right for a win. Then Checks each column,
																										//starting at the bottom, reading diagonal up and right for a win.
																										
int main(){
	
	int i = 0;
	int winner = 0;
	char PLAYER_ONE_PIECE = 'o';
	char PLAYER_TWO_PIECE = 'x';
	char connectFourBoard[NUM_ROWS][NUM_COLUMNS] = 
	{{" 1 2 3 4 5 6 7"},//i = 0
	 {"|_|_|_|_|_|_|_|"},//i = 1
	 {"|_|_|_|_|_|_|_|"},//i = 2
	 {"|_|_|_|_|_|_|_|"},//i = 3
	 {"|_|_|_|_|_|_|_|"},//i = 4
	 {"|_|_|_|_|_|_|_|"},//i = 5
	 {"|_|_|_|_|_|_|_|"},//i = 6
	 {"---------------"} //i = 7
	};
	
	while (!winner){
		OPlayerTurn(connectFourBoard, PLAYER_ONE_PIECE);
		if (!winner){winner = winnerHorizontal(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
		if (!winner){winner = winnerVertical(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
		if (!winner){winner = winnerDiagnal(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
		if (winner){break;}
		
		XPlayerTurn(connectFourBoard, PLAYER_TWO_PIECE);
		if (!winner){winner = winnerHorizontal(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
		if (!winner){winner = winnerVertical(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
		if (!winner){winner = winnerDiagnal(connectFourBoard, PLAYER_ONE_PIECE, PLAYER_TWO_PIECE, winner);}
	}
	if (winner == 1){printf("\nPlayer One Wins!!");}
	if (winner == 2){printf("\nPlayer Two Wins!!");}
}


void OPlayerTurn(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE){ //Prints the board. Let's P1 drop a piece. Changes the board. 
	int rowToThrow;
	int pieceDropping = 1;
	int i = 0;
	int k = 0;
	
	printf("\n\n\n\n\nPlayer 1.\n\n"); //When I say row, I mean columm.
	do{//Loops if the row selected is full. won't change the board in that case.
	DRAW_BOARD;
		printf("\n\nSelect a row to drop your piece.\n");
		scanf(" %d", &rowToThrow);
		if (rowToThrow > 7){rowToThrow = 7;}//ensures that the row selected is on the board.
		if (rowToThrow < 1){rowToThrow = 1;}
		if (board[1][rowToThrow*2-1] == '_'){ //Checks to make sure the row isn't full first.
			i = 0;
			while(pieceDropping){ //starts from the bottom and searches up that row for the first empty space. Puts P1's piece there.
				if (board[NUM_ROWS - i][rowToThrow*2-1] == '_'){
					board[NUM_ROWS - i][rowToThrow*2-1] = PLAYER_ONE_PIECE;
					pieceDropping = 0;
				}
				i++;
			}
		}
	}while(board[1][rowToThrow*2-1] != '_');
}

void XPlayerTurn(char board[][NUM_COLUMNS], char PLAYER_TWO_PIECE){ //Prints the board. Let's P2 drop a piece. Changes the board. 
	int rowToThrow;
	int pieceDropping = 1;
	int i = 0;
	int k = 0;
	
	printf("\n\n\n\n\nPlayer 2.\n\n");
	do{ //Loops if the row selected is full. won't change the board in that case.
	DRAW_BOARD;
	printf("Select a row to drop your piece.\n");
	scanf(" %d", &rowToThrow);
	if (rowToThrow > 7){rowToThrow = 7;} //Makes sure the row selected is on the board.
	if (rowToThrow < 1){rowToThrow = 1;}
	if (board[1][rowToThrow*2-1] == '_'){ //checks to make sure the row isn't full first.
		i = 0;
		while(pieceDropping){//starts from the bottom and searches up that row for the first empty space. Puts P2's piece there.
			if (board[NUM_ROWS - i][rowToThrow*2-1] == '_'){
				board[NUM_ROWS - i][rowToThrow*2-1] = PLAYER_TWO_PIECE;
				pieceDropping = 0;
			}
			i++;
		}
	}
	}while (board[1][rowToThrow*2-1] != '_');
}

int winnerHorizontal (char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner){ // Returns 1 if P1 won horizontally. Returns 2 if P2 won horizontally.
	int i = 1;
	int j = 1;
	winner = 0;
	int k = 0;
	
	for (i=1; i<NUM_ROWS-1; i++){//for every row
//	printf("\n");
		for (j=1; j<NUM_COLUMNS/2; j+=2){//for every column
			if (board[i][j] == PLAYER_ONE_PIECE  && board[i][j+2] == board[i][j] && board[i][j+4] == board[i][j]&& board[i][j+6] == board[i][j]){
				DRAW_BOARD; //^Checks if player 1 has a piece at the current space. Then compares the next three spaces across to it.
				winner = 1;
			}
			if (board[i][j] == PLAYER_TWO_PIECE && board[i][j+2] == board[i][j] && board[i][j+4] == board[i][j]&& board[i][j+6] == board[i][j]){
				DRAW_BOARD;	//^Checks if Player 2 has a piece at the current space. Then compares the next three spaces across to it.
				winner = 2;
			}
		}//Moves to the next space across.
	}//Moves to the next row down.
	return(winner);
}

int winnerVertical(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner){
	int i = 1;
	int j = 1;
	winner = 0;
	int k = 0;

	for (j=1; j<NUM_COLUMNS;j+=2){//for every column
		for (i=1; i<NUM_ROWS - 3; i++){
			if (board[i][j] == PLAYER_ONE_PIECE && board[i+1][j] == board[i][j] && board[i+2][j] == board[i][j] && board[i+3][j] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 1 has a piece at the current space. Then compares it to the next three spaces down.
				winner = 1;
			}
			if (board[i][j] == PLAYER_TWO_PIECE && board[i+1][j] == board[i][j] && board[i+2][j] == board[i][j] && board[i+3][j] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 2 has a piece at the current space. Then compares it to the next three spaces down.
				winner = 2;
			}
		}//Moves to the next row down.
	}//Moves to the next space across.
	return(winner);
}

int winnerDiagnal(char board[][NUM_COLUMNS], char PLAYER_ONE_PIECE, char PLAYER_TWO_PIECE, int winner){
	int i = 1;
	int j = 1;
	winner = 0;
	int k = 0;
	
	for (j = 1; j < NUM_COLUMNS/2; j+=2){//down and right diagnal == (+1, +2).
		for (i = 1; i < NUM_ROWS - 3; i++){
			if (board[i][j] == PLAYER_ONE_PIECE && board[i+1][j+2] == board[i][j] && board[i+2][j+4] == board[i][j] && board[i+3][j+6] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 1 has a piece at the current space. Then compares the next 3 pieces diagonally down and right to it.
				winner = 1;
			}
			if (board[i][j] == PLAYER_TWO_PIECE && board[i+1][j+2] == board[i][j] && board[i+2][j+4] == board[i][j] && board[i+3][j+6] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 2 has a piece at the current space. Then compares the next 3 pieces diagonally down and right to it.
				winner = 2;
			}
		}//moves to the next row down.
	}//Moves to the next space across.
	i = (NUM_ROWS-1);
	j = 1;
	for (j = 1; j < NUM_COLUMNS/2; j+=2){//up and right diagnal == (-1, +2)
		for (i = 7; i > 3; i--){
			if (board[i][j] == PLAYER_ONE_PIECE && board[i-1][j+2] == board[i][j] && board[i-2][j+4] == board[i][j] && board[i-3][j+6] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 1 has a piece at the current space. Then compares the next 3 pieces diagonally up and right to it.
				winner = 1;
			}
			if (board[i][j] == PLAYER_TWO_PIECE && board[i-1][j+2] == board[i][j] && board[i-2][j+4] == board[i][j] && board[i-3][j+6] == board[i][j]){
				DRAW_BOARD;//^Checks if Player 2 has a piece at the current space. Then compares the next 3 pieces diagonally up and right to it.
				winner = 2;
				fflush(stdout);
			}
		}//Moves to the next row up.
	}//Moves to the next space across.
	return(winner);
}




