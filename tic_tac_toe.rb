# Some of this abstraction might be unnecessarily complex, but practicing OOP is more important

require 'pry-byebug'

class Game
    attr_accessor :board


    def initialize
        # @player1 = create_player(1)
        # @player2 = create_player(2)
        @player1 = Player.new("Robert", 1)
        @player2 = Player.new("John", 2)
        @board = Board.new
    end

    def play_game
        @board.render_board
        while true
            play_round
        end
    end

    # need to make the code more modular so code isn't repeated
    def play_round
        
        puts "Enter move for Player##{@player1.number} #{@player1.name}:"
        while player1_move = decodeRowCol(gets.chomp)
            if @board.unclaimed_cell?(player1_move)
                @board.mark_cell(player1_move, @player1)
                break
            else
                puts "Cell already claimed"
            end
        end

        @board.render_board

        puts "Enter move for Player##{@player2.number} #{@player2.name}:"
        while player2_move = decodeRowCol(gets.chomp)
            if @board.unclaimed_cell?(player2_move)
                @board.mark_cell(player2_move, @player2)
                break
            else
                puts "Cell already claimed"
            end
        end

        
        @board.render_board
    end

    def create_player(number)
        puts "Enter Player ##{number} name: "
        player_name = gets.chomp

        Player.new(player_name, number)
    end

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


# result = a_game.decodeRowCol("c3")

# puts "row: #{result[0]}"
# puts "col: #{result[1]}"

# player1 = Player.new("Robert", 1)
# player2 = Player.new("John", 2)

# a_board = Board.new
# a_board.render_board
# a_board.mark_cell(0,0,player2)
# a_board.render_board