# Some of this abstraction might be unnecessarily complex, but practicing OOP is more important

require 'pry-byebug'

class Game

    def initialize
        @players = []
        @board = Board.new
    end

    # number of players is hard coded to 2
    def play_game
        # @player1 = create_player(1)
        # @player2 = create_player(2)
        @player1 = Player.new("Robert", 1)
        # @player2 = Player.new("John", 2)
        @players.push(@player1)
        # @players.push(@player2)

        @board.render_board # render starting board

        catch :exit_game do # for stopping the game when there is a winner
            while true
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

    def player_move(player)
        puts "Enter move for Player ##{player.number} #{player.name}:"
        while player_move = decodeRowCol(gets.chomp)
            if @board.unclaimed_cell?(player_move)
                @board.mark_cell(player_move, player)
                break
            else
                puts "Cell already claimed"
            end
        end
    end

    def create_player(number)
        puts "Enter Player ##{number} name: "
        player_name = gets.chomp

        Player.new(player_name, number)
    end

    # returns [row, col]
    # helper function for accepting user input (#play_round)
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

    # [row, col]
    # win_coordinates are for a 3x3 board
    # return player object if one has won the game, return nil if nobody has won
    def find_winning_player
        
        # optional: an algorithm can be made to compute this for a n-sized board
        row_coordinates = [[[0,0],[0,1],[0,2]], [[1,0],[1,1],[1,2]], [[2,0],[2,1],[2,2]]]
        col_coordinates = [[[0,0],[1,0],[2,0]], [[0,1],[1,1],[2,1]], [[0,2],[1,2],[2,2]]]
        diagonal_coordinates = [[[0,0],[1,1],[2,2]], [[0,2],[1,1],[2,0]]]

        win_coordinates = row_coordinates + col_coordinates + diagonal_coordinates

        win_coordinates.each do |tuple_coordinates|
            # cell objects grabbed from each tuple coordinate
            tuple_cell = []

            tuple_coordinates.each do |coordinate|
                cell = @board.return_cell(coordinate)
                tuple_cell.push(cell)
            end

           if tuple_cell.all? {|cell| cell.player == @player1}
            return @player1
           elsif tuple_cell.all? {|cell| cell.player == @player2} 
            return @player2
           else
            return nil
           end
        end
    end

end

class Board
    attr_reader :board

    def initialize
        # create 3x3 board of Cell objects
        @board = Array.new(3) { Array.new(3) {Cell.new}}
    end

    public
    # display the current state of the game
    def render_board
        puts "   [A] [B] [C]"
        puts "[1] #{@board[0][0].to_s} | #{@board[0][1].to_s} | #{@board[0][2].to_s} "
        puts "[2] #{@board[1][0].to_s} | #{@board[1][1].to_s} | #{@board[1][2].to_s} "
        puts "[3] #{@board[2][0].to_s} | #{@board[2][1].to_s} | #{@board[2][2].to_s}"
        puts "-------------"
    end

    def unclaimed_cell?(array)
        row = array[0]
        col = array[1]
        cell = @board[row][col]

        if(cell.player == nil)
            return true
        else
            return false
        end
    end

    def mark_cell (array, player)
        row = array[0]
        col = array[1]
        cell = @board[row][col]

        if(unclaimed_cell?(array))
            cell.set_mark(player)
        else
            puts "Error: cell has already been claimed"
            return nil
        end
    end

    def return_cell (array)
        row = array[0]
        col = array[1]

        @board[row][col]
    end
end

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
class Cell
    attr_accessor :player
    attr_accessor :mark
    
    def initialize()
        @player = nil
        @mark = nil
    end

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

    def to_s
        if(@mark == nil)
            return " "
        else
            return @mark
        end
    end

end

# binding.pry

a_game = Game.new
a_game.play_game

#a_game.find_winning_player


# result = a_game.decodeRowCol("c3")

# puts "row: #{result[0]}"
# puts "col: #{result[1]}"

# player1 = Player.new("Robert", 1)
# player2 = Player.new("John", 2)

# a_board = Board.new
# a_board.render_board
# a_board.mark_cell(0,0,player2)
# a_board.render_board