require 'timeout'

class SolutionsController < ApplicationController
  before_action :set_solution, only: [:show, :edit, :update, :destroy, :retest]

  # GET /solutions
  # GET /solutions.json
  def index
    @solutions = Solution.all
  end

  # GET /solutions/1
  # GET /solutions/1.json
  def show
    if @solution.status.blank?
      run_compiler
    end
  end

  # GET /solutions/new
  def new
    @solution = Solution.new
  end

  # GET /solutions/1/edit
  def edit
  end

  # POST /solutions
  # POST /solutions.json
  def create
    compiler_id = compiler_params[:compiler_id]
    problem_id = problem_params[:problem_id]

    @solution = Solution.new(solution_params)

    @solution.compiler = Compiler.find(compiler_id)
    @solution.problem = Problem.find(problem_id)

    respond_to do |format|
      if @solution.save
        run_compiler

        format.html { redirect_to @solution, notice: 'Solution was successfully created.' }
        format.json { render action: 'show', status: :created, location: @solution }
      else
        format.html { render action: 'new' }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solutions/1
  # PATCH/PUT /solutions/1.json
  def update
    respond_to do |format|
      if @solution.update(solution_params)
        format.html { redirect_to @solution, notice: 'Solution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    @solution.destroy
    respond_to do |format|
      format.html { redirect_to solutions_url }
      format.json { head :no_content }
    end
  end

  def retest
    @solution.retest
    redirect_to @solution
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compiler_params
      params.permit(:compiler_id)
    end

    def problem_params
      params.permit(:problem_id)
    end

    def solution_params
      params.require(:solution).permit(:body)
    end

    def run_compiler
      scheduler = Rufus::Scheduler.new

      scheduler.in '3s' do
        next if @solution.status.present?

        @solution.update_attribute :status, 'compiling'

        # 1. create tempfile and fill it with source code
        # 2. parse compiler command and replace: 
        ## a. $SOURCE_PATH with tempfile path
        ## b. $BINARY_PATH with resulting binary path
        # 3. run compiler command. store exit code.
        # 4. if exit code == 0 -> run tests in sequency
        # 5. update solution state

        solutions_path = File.join(Rails.root, 'tmp', 'solutions')

        source_file = File.new(File.join(solutions_path, "solution_#{ @solution.id }"), 'w')
        source_file.write(@solution.body)
        source_file.close

        source_path = source_file.path
        binary_path = File.join(solutions_path, "binary_#{ @solution.id }")

        if @solution.compiler.build_steps.count > 0
          compilation_successfull = false

          @solution.compiler.build_steps.each do |step|
            command = step.command
            command.gsub!(/\$SOURCE_PATH/, source_path)
            command.gsub!(/\$BINARY_PATH/, binary_path)

            Rails.logger.info("BUILD STEP COMMAND: #{command}")
            IO.popen(command, "r") { |f| Rails.logger.info("BUILD STEP OUTPUT: #{f.read}") }

            compilation_successfull = ($? == 0)

            break unless compilation_successfull
          end

          unless compilation_successfull
            @solution.update_attribute :status, 'compilation failed with error'
            next
          end
        end

        @solution.update_attribute :status, 'checking'

        command = @solution.compiler.run_command
        command.gsub!(/\$SOURCE_PATH/, source_path)
        command.gsub!(/\$BINARY_PATH/, binary_path)

        failed_test, timeout_test = -1, -1

        time_limit = @solution.problem.time_limit

        loggings = []

        # parallelism causes timeout not to work
        #Parallel.each_with_index(@solution.problem.solution_tests) do |test, test_index|
        @solution.problem.solution_tests.each_with_index do |test, test_index|
          passed = false

          test_io = nil

          Timeout.timeout(time_limit, Timeout::Error) do
            begin
              test_io = IO.popen(command, 'w+')
              
              test_io.write(test.got)

              output = test_io.readlines.join
              
              passed = (output == test.expected)
              
              unless passed
                loggings << "TEST ##{ test_index } FAILED:"
                loggings << "GIVEN: #{ test.got }"
                loggings << "EXPECTED: #{ test.expected }"
                loggings << "GOT: #{ output }"
              end

              test_io.close
            rescue Timeout::Error => e
              Process.kill 9, test_io.pid
              timeout_test = test_index
              loggings << "TIMED OUT ##{ test_index }: #{ e.message }"
            rescue Exception => e
              failed_test = test_index
              loggings << "EXCEPTION WHILE CHECKING TEST ##{ test_index }: #{ e.message }"
            ensure
              if test_io.present? and not test_io.closed?
                Process.kill 9, test_io.pid
                timeout_test = test_index
              end
            end
          end

          unless passed
            failed_test = test_index
            #raise Parallel::Break
            break
          end
        end

        File.open(File.join(solutions_path, "logs_#{ @solution.id }"), "w") do |log|
          loggings.each do |msg|
            log.puts msg
          end
        end

        if timeout_test > -1
          @solution.update_attribute :status, "test ##{ timeout_test + 1 } timed out"
        elsif failed_test > -1
          @solution.update_attribute :status, "test ##{ failed_test + 1 } failed"
        else
          @solution.update_attribute :status, 'correct'
        end
      end
    end
end
