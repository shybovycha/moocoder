class SolutionsController < ApplicationController
  require 'tempfile'
  
  # GET /solutions
  # GET /solutions.xml
  def index
    @solutions = Solution.all( :order => "created_at desc" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @solutions }
    end
  end

  # GET /solutions/1
  # GET /solutions/1.xml
  def show
    @solution = Solution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @solution }
    end
  end

  # GET /solutions/new
  # GET /solutions/new.xml
  def new
    @solution = Solution.new
    @solution.problem = Problem.find(params[:problem]) if (params[:problem])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @solution }
    end
  end

  # GET /solutions/1/edit
  def edit
    @solution = Solution.find(params[:id])
  end

  # POST /solutions
  # POST /solutions.xml
  def create
	params[:solution][:compiler] = Compiler.find(params[:solution][:compiler]) if (params[:solution][:compiler])
    @solution = Solution.new(params[:solution])
    @solution.problem = Problem.find(params[:problem]) if (params[:problem])
    
    if !@solution.save
		logger.info "Could not save solution"
		return
	end
    
    tmp = File.new("/tmp/sol#{ @solution.id }.#{ @solution.compiler.ext }", "w", 7777)
    tmp.chmod(0777)
	tmp.puts @solution.code
	tmp.close
		
	if @solution.compiler.compiled
		tmp2 = File.new("/tmp/comp#{ @solution.id }.elf", "w")
		tmp2.chmod(0777)
		tmp2.close
			
		@solution.update_attributes( :status => "Compiling...")
		
		compile_cmd = @solution.compiler.cmd_line % [ tmp.path, tmp2.path ]
		
		compile_msg = `#{ compile_cmd } >&1 2>&1`
		compile_res = ($?.exitstatus == 0)
		logger.info ">>> Compiling with: #{compile_cmd} => #{compile_msg.inspect} as #{ compile_res }"
	else
		compile_cmd = @solution.compiler.cmd_line % [ tmp.path ]
		tmp2 = tmp
		compile_res = true
	end
	
	if compile_res
		@solution.update_attributes( :status => "Testing...", :passed => 0)
		
		@solution.problem.test_cases.each do |t|
			p = nil
			
			if (t.given)
				if @solution.compiler.compiled
					p = IO.popen(tmp2.path, "w+")
					
					logger.info ">>> Running with: #{ tmp2.path }"
				else
					p = IO.popen(compile_cmd, "w+")
					
					logger.info ">>> Running with: #{ compile_cmd }"
				end
				
				p.puts t.given if (!t.given.nil?)
				p.close_write
			else
				p = IO.popen(tmp2.path, "r")
			end
			
			run_res = p.read
			
			p.close
			
			t.expected += "\n"
			
			logger.info ">>> Comparing: #{ run_res.inspect } and #{ t.expected.inspect } => #{ run_res == t.expected }"
			
			if run_res == t.expected
				@solution.update_attributes(:passed => @solution.passed + 1)
			end
		end
		
		@solution.update_attributes( :status => "Passed: #{ @solution.passed } / #{ @solution.problem.test_cases.length }")
		
		File.delete(tmp.path) if File.exists?(tmp.path)
		File.delete(tmp2.path) if File.exists?(tmp2.path)
	else
		@solution.update_attributes( :status => "Compiler got an error. I won't show it for you ;)")
	end

    respond_to do |format|
      if @solution.save
        format.html { redirect_to(@solution, :notice => 'Solution was successfully created.') }
        format.xml  { render :xml => @solution, :status => :created, :location => @solution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @solution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /solutions/1
  # PUT /solutions/1.xml
  def update
    @solution = Solution.find(params[:id])

    respond_to do |format|
      if @solution.update_attributes(params[:solution])
        format.html { redirect_to(@solution, :notice => 'Solution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @solution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.xml
  def destroy
    @solution = Solution.find(params[:id])
    @solution.destroy

    respond_to do |format|
      format.html { redirect_to(solutions_url) }
      format.xml  { head :ok }
    end
  end
end
