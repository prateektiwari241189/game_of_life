require 'rspec'
require_relative 'world.rb'
require_relative 'cell.rb'
require_relative 'game.rb'

describe 'Game of life' do

  let!(:cell) { Cell.new(1,1) }
  let!(:world) { World.new }
  let!(:game) { Game.new(world, [[1, 1]]) }
  # let!(:window) { GameOfLifeWindow.new }

  context 'world' do
	subject {World.new}	
	it 'create new world object' do 
		expect(subject.is_a?(World)).to be true
	end
	it 'should respond to proper methods' do
		subject.should respond_to(:rows)
		subject.should respond_to(:cols)
		subject.should respond_to(:cell_grid)
    subject.should respond_to(:live_neighbours_around_cell)
    subject.should respond_to(:cells)
    subject.should respond_to(:randomly_populate)
	end
	it 'create proper cell grid on initialization' do
		expect(subject.cell_grid.is_a?(Array)).to be true
		subject.cell_grid.each do |row|
			expect(row.is_a?(Array)).to be true
			row.each do |col|
				expect(col.is_a?(Cell)).to be true
			end
		end
	end

  it 'should add all cells to cells array' do 
    subject.cells.count.should == 9
  end

  it 'should detect a neighbour to the north' do
    subject.cell_grid[0][1].should be_dead
    subject.cell_grid[0][1].alive = true
    subject.cell_grid[0][1].should be_alive
    subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count.should == 1
  end

  it 'Detects live neighbour to the south' do
      subject.cell_grid[cell.y + 1][cell.x].alive = true
      subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count.should == 1
  end

  it 'Detects live neighbour to the east' do
      subject.cell_grid[cell.y][cell.x + 1].alive = true
      subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count.should == 1
  end

  it 'Detects live neighbour to the west' do
      subject.cell_grid[cell.y][cell.x - 1].alive = true
      subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count.should == 1
  end

  it 'Detects live neighbour to the north-east' do
      subject.cell_grid[cell.y - 1][cell.x + 1].alive = true
      subject.live_neighbours_around_cell(cell).count.should == 1
  end

  it 'Detects live neighbour to the south-east' do
      subject.cell_grid[cell.y + 1][cell.x + 1].alive = true
      subject.live_neighbours_around_cell(cell).count.should == 1
  end

  it 'Detects live neighbour to the south-west' do
      subject.cell_grid[cell.y + 1][cell.x - 1].alive = true
      subject.live_neighbours_around_cell(cell).count.should == 1
  end

  it 'Detects live neighbour to the north-west' do
      subject.cell_grid[cell.y - 1][cell.x - 1].alive = true
      subject.live_neighbours_around_cell(cell).count.should == 1
  end

  it 'Randomly populates the world' do
      subject.live_cells.should == []
      subject.randomly_populate
      subject.live_cells.should_not == []
    end

  end

  context 'cell' do
  	subject{Cell.new}
  	it 'should create a new cell object' do
  		expect(subject.is_a?(Cell)).to be true
  	end
  	it 'should respond to proper methods' do
  		subject.should respond_to(:alive)
  		subject.should respond_to(:x)
  		subject.should respond_to(:y)
      subject.should respond_to(:alive?)
      subject.should respond_to(:die!)
  	end
  	it 'should initialize properly' do
  		expect(subject.alive).to be false
  		expect(subject.x) == 0
  		expect(subject.y) == 0
  	end
  end

  context 'Game' do 
  	subject {Game.new}

  	it 'should create a game object' do
  		expect(subject.is_a?(Game)).to be true
  	end

  	it 'should respond to proper methods' do
  		subject.should respond_to(:world)
  		subject.should respond_to(:seeds)
  	end

  	it 'should initialize properly' do
  		expect(subject.world.is_a?(World)).to be true
  		expect(subject.seeds.is_a?(Array)).to be true
  	end

    it 'should plant the seeds properly' do
      game = Game.new(world, [[0,1],[1,1]])
      expect(game.world.cell_grid[0][1].alive).to be true
      expect(game.world.cell_grid[1][1].alive).to be true
    end

  end

  context 'Rules' do 

  	let!(:game) {Game.new}

  	context 'Rule 1Any live cell with fewer than two live neighbours dies, as if caused by under-population.' do
  		it 'Kills live cell with no neighbours' do
        game.world.cell_grid[1][1].alive = true
        game.world.cell_grid[1][1].should be_alive
        game.tick!
        game.world.cell_grid[1][1].should be_dead
      end

      it 'Kills live cell with 1 live neighbour' do
        game = Game.new(world, [[0, 1], [1, 1]])
        game.tick!
        game.world.cell_grid[0][1].should be_dead
        game.world.cell_grid[1][1].should be_dead
      end

      it 'Doesnt kill live cell with 2 neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        game.tick!
        world.cell_grid[1][1].should be_alive
      end

  	end

    context 'Rule #2: Any live cell with two or three live neighbours lives on to the next generation.' do
      it 'Should keep alive cell with 2 neighbours to next generation' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        world.live_neighbours_around_cell(world.cell_grid[1][1]).count.should == 2
        game.tick!
        world.cell_grid[0][1].should be_dead
        world.cell_grid[1][1].should be_alive
        world.cell_grid[2][1].should be_dead
      end
    end
     context 'Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding.' do
      it 'Should kill live cell with more than 3 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2], [1, 2]])
        world.live_neighbours_around_cell(world.cell_grid[1][1]).count.should == 4
        game.tick!
        world.cell_grid[0][1].should be_alive
        world.cell_grid[1][1].should be_dead
        world.cell_grid[2][1].should be_alive
        world.cell_grid[2][2].should be_alive
        world.cell_grid[1][2].should be_dead
      end
    end

    context 'Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
      it 'Revives dead cell with 3 neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        world.live_neighbours_around_cell(world.cell_grid[1][0]).count.should == 3
        game.tick!
        world.cell_grid[1][0].should be_alive
        world.cell_grid[1][2].should be_alive
      end
    end
  end
end