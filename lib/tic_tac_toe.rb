# Some of this abstraction might be unnecessarily complex, but practicing OOP design is more important

class Game

    #initialize a blank game
    def initialize
        @players = []
        @board = Board.new
    end

    # number of players is hard coded to 2
    def play_game

        # Ask each player for their name, create player objects and push to players array
        @player1 = create_player(1)
        @player2 = create_player(2)
        @players.push(@player1)
        @players.push(@player2)

        @board.render_board # render starting board

        catch :exit_game do # for stopping the game when there is a winner
            while true
                # ask for each player's moves and update the board until there is a winner
                @players.each do |player|
                    player_move(player)
                    @board.render_board

                    # check if a player has won. If true, display a message and stop the game
                    if (find_winning_player)
                        player = find_winning_player
                        puts "Player ##{player.number}: #{player.name} has won"
                        throw :exit_game
                    end
                end
            end
        end
    end

    # Ask the player for a move. If the cell is unclaimed, update the board. If the cell is already claimed, return an error an ask for another move
    def player_move(player)
        puts "Enter move for Player ##{player.number} #{player.name}:"
        while player_move = decodeRowCol(gets.chomp)
            if @board.unclaimed_cell?(player_move)
                @board.mark_cell(player_move, player)
                break
            else
                claimed_cell = @board.return_cell(player_move)
                
                puts "Cell already claimed by Player ##{claimed_cell.player.number} #{claimed_cell.player.name}"
            end
        end
    end

    # For a given player number, ask player for a name. Return a player object
    def create_player(number)
        puts "Enter Player ##{number} name: "
        player_name = gets.chomp

        Player.new(player_name, number)
    end

    
    # Helper function for accepting user input
    # Board rows and columns are displayed in a user-friendly way (Row: 1, 2, 3. Col: A, B, C). This method converts a user choice into [row, col].
    # returns [row, col]
    def decodeRowCol(string)
        
        result = []
        row = (string[1,2].to_i) - 1
        if (row >= 0 || row < 3)
            result.push(row)
        else
            puts "Invalid row"
        end

        col_letter = string[0,1].upcase
        if (col_letter == "A")
            result.push(0)
        elsif (col_letter == "B")
            result.push(1)
        elsif (col_letter == "C")
            result.push(2)
        else
            puts "Invalid column"
        end

        result
    end

    # Return player object if one has won the game, return nil if nobody has won
    # Win_coordinates are hardcoded for a 3x3 board
    def find_winning_player
        
        # optional: an algorithm can be made to compute this for a n-sized board
        row_coordinates = [[[0,0],[0,1],[0,2]], [[1,0],[1,1],[1,2]], [[2,0],[2,1],[2,2]]]
        col_coordinates = [[[0,0],[1,0],[2,0]], [[0,1],[1,1],[2,1]], [[0,2],[1,2],[2,2]]]
        diagonal_coordinates = [[[0,0],[1,1],[2,2]], [[0,2],[1,1],[2,0]]]

        win_coordinates = row_coordinates + col_coordinates + diagonal_coordinates

        win_coordinates.each do |tuple_coordinates|
            # cell objects grabbed from each coordinate in tuple
            tuple_cell = []

            tuple_coordinates.each do |coordinate|
                cell = @board.return_cell(coordinate)
                tuple_cell.push(cell)
            end

           if tuple_cell.all? {|cell| cell.player == @player1}
            return @player1
           elsif tuple_cell.all? {|cell| cell.player == @player2} 
            return @player2
           end
        end

        nil
    end
end

class Board

    def initialize
        # create 3x3 board of Cell objects
        @board = Array.new(3) { Array.new(3) {Cell.new}}
    end

    public
    # display the current state of the game
    def render_board
        puts "   [A] [B] [C]"
        puts "[1] #{@board[0][0]} | #{@board[0][1]} | #{@board[0][2]} "
        puts "[2] #{@board[1][0]} | #{@board[1][1]} | #{@board[1][2]} "
        puts "[3] #{@board[2][0]} | #{@board[2][1]} | #{@board[2][2]}"
        puts "-------------"
    end

    # return the cell object at a coordinate
    def return_cell(coordinate)
        row = coordinate[0]
        col = coordinate[1]

        @board[row][col]
    end

    # return true if the cell at coordinate has been claimed by a player
    def unclaimed_cell?(coordinate)
        cell = return_cell(coordinate)

        if(cell.player == nil)
            return true
        else
            return false
        end
    end

    def mark_cell(coordinate, player)
        cell = return_cell(coordinate)

        if(unclaimed_cell?(coordinate))
            cell.set_mark(player)
        else
            puts "Error: cell has already been claimed"
            return nil
        end
    end
end

# a player object contains its name and player number
class Player
    attr_reader :name
    attr_reader :number

    def initialize(name, number)
        @name = name
        @number = number
    end
end

# Player 1 = X
# Player 2 = 0
# A cell contains the "mark" on the board and its associated player
class Cell
    attr_accessor :player
    attr_accessor :mark
    
    def initialize()
        @player = nil
        @mark = nil
    end

    # Mark the cell for a player
    def set_mark(player)
        @player = player
        if (player.number == 1)
            @mark = "X"
        elsif(player.number == 2)
            @mark = "O"
        else
            puts "Wrong player number entered"
        end
    end

    # important for displaying the board using Board#render_board
    def to_s
        if(@mark == nil)
            return " "
        else
            return @mark
        end
    end

end

a_game = Game.new
a_game.play_game